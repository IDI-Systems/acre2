//! A connected client with live audio: microphone → transmitter → server → mixer → speakers.

use std::{
    sync::{
        Arc, Mutex, MutexGuard,
        atomic::{AtomicBool, AtomicU32, Ordering},
        mpsc as std_mpsc,
    },
    thread::JoinHandle,
    time::{Duration, Instant},
};

use acre2_voice_codec::{CodecError, EncoderConfig, JitterConfig, SAMPLE_RATE};
use acre2_voice_proto::{ServerMsg, TxId};
use tokio::sync::mpsc;
use tracing::debug;

use super::{
    ActivationConfig, Loopback, Looped, Mixer, Renderer, Transmitter,
    device::{DeviceCallback, DeviceEvent, Devices, PUMP_INTERVAL, Rings},
    resample::Resampler,
};
use crate::{Client, ClientEvent};

/// Audio queued for the speakers ahead of playback. Lower is snappier; higher survives
/// scheduling hiccups.
const PLAYBACK_LEAD_MS: u32 = 60;

#[derive(Debug, Clone, Default)]
pub struct SessionConfig {
    pub encoder: EncoderConfig,
    pub jitter: JitterConfig,
    pub activation: ActivationConfig,
    /// Device ids (or names) from [`super::list_devices`]; `None` for the system default.
    pub input_device: Option<String>,
    pub output_device: Option<String>,
}

/// Something the application should know about.
#[derive(Debug, Clone, PartialEq)]
pub enum SessionEvent {
    /// A control message from the server (transmission start/end, errors, …).
    Server(ServerMsg),
    Device(DeviceEvent),
    /// One of our own transmissions started or stopped sending (a talk spurt began or ended).
    Transmitting {
        tx: TxId,
        active: bool,
    },
    /// The connection closed; the session is dead.
    Closed {
        reason: String,
    },
}

/// Shared between the session handle and its threads.
struct Shared {
    client: Client,
    transmitter: Mutex<Transmitter>,
    mixer: Mutex<Mixer>,
    renderer: Mutex<Box<dyn Renderer>>,
    epoch: Instant,
    /// Microphone level of the last frame, `f32` bits.
    level_bits: AtomicU32,
    events: std_mpsc::Sender<SessionEvent>,
}

impl Shared {
    fn now_ms(&self) -> u64 {
        self.epoch.elapsed().as_millis() as u64
    }
}

/// The device threads of one device configuration.
struct Pipeline {
    stop: Arc<AtomicBool>,
    threads: Vec<JoinHandle<()>>,
    _devices: Devices,
}

impl Pipeline {
    fn start(
        shared: &Arc<Shared>,
        input: Option<String>,
        output: Option<String>,
        events: DeviceCallback,
    ) -> Self {
        let (devices, rings) = Devices::open(input, output, events);
        let Rings {
            capture,
            playback,
            output_rate,
            output_active,
        } = rings;
        let stop = Arc::new(AtomicBool::new(false));
        let threads = vec![
            spawn("acre2-voice-tx", {
                let (shared, stop) = (shared.clone(), stop.clone());
                move || transmit_loop(&shared, &stop, capture)
            }),
            spawn("acre2-voice-mix", {
                let (shared, stop) = (shared.clone(), stop.clone());
                move || mix_loop(&shared, &stop, playback, output_rate, output_active)
            }),
        ];
        Self {
            stop,
            threads,
            _devices: devices,
        }
    }
}

impl Drop for Pipeline {
    fn drop(&mut self) {
        self.stop.store(true, Ordering::Relaxed);
        for t in self.threads.drain(..) {
            let _ = t.join();
        }
    }
}

fn spawn(name: &str, f: impl FnOnce() + Send + 'static) -> JoinHandle<()> {
    std::thread::Builder::new()
        .name(name.into())
        .spawn(f)
        .expect("spawning audio thread")
}

/// A live voice session. Dropping it stops audio and disconnects.
pub struct VoiceSession {
    shared: Arc<Shared>,
    pipeline: Mutex<Option<Pipeline>>,
    device_events: DeviceCallback,
    pump: tokio::task::JoinHandle<()>,
}

impl std::fmt::Debug for VoiceSession {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("VoiceSession")
            .field("peer_id", &self.shared.client.peer_id())
            .finish_non_exhaustive()
    }
}

impl VoiceSession {
    /// Starts audio for a connected client. Must be called inside a tokio runtime.
    pub fn start(
        client: Client,
        client_events: mpsc::Receiver<ClientEvent>,
        config: SessionConfig,
        renderer: Box<dyn Renderer>,
    ) -> Result<(Self, std_mpsc::Receiver<SessionEvent>), CodecError> {
        let (app_tx, app_rx) = std_mpsc::channel();
        let shared = Arc::new(Shared {
            client,
            transmitter: Mutex::new(Transmitter::new(config.encoder, config.activation)?),
            mixer: Mutex::new(Mixer::new(config.jitter)),
            renderer: Mutex::new(renderer),
            epoch: Instant::now(),
            level_bits: AtomicU32::new((-100.0f32).to_bits()),
            events: app_tx.clone(),
        });
        let device_events: DeviceCallback = {
            let app_tx = Mutex::new(app_tx.clone());
            Arc::new(move |e| {
                let _ = app_tx.lock().expect("lock").send(SessionEvent::Device(e));
            })
        };
        let pump = tokio::spawn(pump(shared.clone(), client_events, app_tx));
        let pipeline = Pipeline::start(
            &shared,
            config.input_device,
            config.output_device,
            device_events.clone(),
        );
        Ok((
            Self {
                shared,
                pipeline: Mutex::new(Some(pipeline)),
                device_events,
                pump,
            },
            app_rx,
        ))
    }

    #[must_use]
    pub fn client(&self) -> &Client {
        &self.shared.client
    }

    /// Controls what's transmitted: direct speech targets, PTT keys, activation, mute.
    pub fn transmitter(&self) -> MutexGuard<'_, Transmitter> {
        self.shared.transmitter.lock().expect("transmitter lock")
    }

    /// Received streams and local mutes.
    pub fn mixer(&self) -> MutexGuard<'_, Mixer> {
        self.shared.mixer.lock().expect("mixer lock")
    }

    /// The renderer, e.g. to update per-speaker effect parameters.
    pub fn renderer(&self) -> MutexGuard<'_, Box<dyn Renderer>> {
        self.shared.renderer.lock().expect("renderer lock")
    }

    /// Microphone level of the last frame in dBFS (−100 when silent or no microphone).
    #[must_use]
    pub fn mic_level_db(&self) -> f32 {
        f32::from_bits(self.shared.level_bits.load(Ordering::Relaxed))
    }

    /// Reopens audio with other devices (`None` for the system default).
    pub fn set_devices(&self, input: Option<String>, output: Option<String>) {
        let mut pipeline = self.pipeline.lock().expect("pipeline lock");
        // Close the old devices first; some drivers refuse a second open.
        pipeline.take();
        *pipeline = Some(Pipeline::start(
            &self.shared,
            input,
            output,
            self.device_events.clone(),
        ));
    }
}

impl Drop for VoiceSession {
    fn drop(&mut self) {
        self.pipeline.lock().expect("pipeline lock").take();
        self.pump.abort();
        self.shared.client.close();
    }
}

/// Network → mixer, and control messages → application.
async fn pump(
    shared: Arc<Shared>,
    mut events: mpsc::Receiver<ClientEvent>,
    app: std_mpsc::Sender<SessionEvent>,
) {
    while let Some(ev) = events.recv().await {
        match ev {
            ClientEvent::Voice(v) => {
                let now = shared.now_ms();
                if let Err(e) = shared
                    .mixer
                    .lock()
                    .expect("mixer lock")
                    .handle_voice(v, now)
                {
                    debug!(error = %e, "voice frame dropped");
                }
            }
            ClientEvent::Message(m) => {
                let now = shared.now_ms();
                let _ = shared
                    .mixer
                    .lock()
                    .expect("mixer lock")
                    .handle_message(&m, now);
                let _ = app.send(SessionEvent::Server(m));
            }
            ClientEvent::Closed { reason } => {
                let _ = app.send(SessionEvent::Closed { reason });
                break;
            }
        }
    }
}

/// Microphone ring → transmitter → network.
fn transmit_loop(shared: &Shared, stop: &AtomicBool, mut capture: rtrb::Consumer<f32>) {
    let frame = shared
        .transmitter
        .lock()
        .expect("transmitter lock")
        .frame_samples();
    let mut buf: Vec<f32> = Vec::with_capacity(frame * 4);
    let mut loopback = Loopback::default();
    while !stop.load(Ordering::Relaxed) {
        let n = capture.slots();
        if let Ok(chunk) = capture.read_chunk(n) {
            let (a, b) = chunk.as_slices();
            buf.extend_from_slice(a);
            buf.extend_from_slice(b);
            chunk.commit_all();
        }
        while buf.len() >= frame {
            let (actions, looped) = {
                let mut t = shared.transmitter.lock().expect("transmitter lock");
                let actions = t.process(&buf[..frame]);
                shared
                    .level_bits
                    .store(t.level_db().to_bits(), Ordering::Relaxed);
                let looped = match &actions {
                    Ok(a) => {
                        loopback.copy(&t, a, shared.client.peer_id(), shared.client.external_id())
                    }
                    Err(_) => Vec::new(),
                };
                (actions, looped)
            };
            buf.drain(..frame);
            deliver_locally(shared, looped);
            match actions {
                Ok(actions) => {
                    // Stops before starts, so a switch (e.g. direct → radio) reads as one ending
                    // and the other beginning.
                    let mut events: Vec<(TxId, bool)> = actions
                        .iter()
                        .filter_map(|a| match a {
                            super::TxAction::Start { tx, .. } => Some((*tx, true)),
                            super::TxAction::Stop { tx } => Some((*tx, false)),
                            super::TxAction::Voice { .. } => None,
                        })
                        .collect();
                    events.sort_by_key(|(_, active)| *active);
                    for (tx, active) in events {
                        let _ = shared
                            .events
                            .send(SessionEvent::Transmitting { tx, active });
                    }
                    super::apply_actions(&shared.client, actions);
                }
                Err(e) => debug!(error = %e, "encoding failed"),
            }
        }
        std::thread::sleep(PUMP_INTERVAL);
    }
}

/// Our looped-back transmissions, into the mixer and the events like remote ones.
fn deliver_locally(shared: &Shared, looped: Vec<Looped>) {
    if looped.is_empty() {
        return;
    }
    let now = shared.now_ms();
    for l in looped {
        match l {
            Looped::Voice(v) => {
                let _ = shared
                    .mixer
                    .lock()
                    .expect("mixer lock")
                    .handle_voice(v, now);
            }
            Looped::Message(m) => {
                let _ = shared
                    .mixer
                    .lock()
                    .expect("mixer lock")
                    .handle_message(&m, now);
                let _ = shared.events.send(SessionEvent::Server(m));
            }
        }
    }
}

/// Mixer → playback ring, paced by the device (or by the clock without one).
fn mix_loop(
    shared: &Shared,
    stop: &AtomicBool,
    mut playback: rtrb::Producer<f32>,
    output_rate: u32,
    output_active: bool,
) {
    let mut left_rs = Resampler::new(SAMPLE_RATE, output_rate);
    let mut right_rs = Resampler::new(SAMPLE_RATE, output_rate);
    let (mut left, mut right, mut interleaved) = (Vec::new(), Vec::new(), Vec::new());
    let capacity = playback.buffer().capacity();
    let lead = (output_rate * 2 * PLAYBACK_LEAD_MS / 1000) as usize;
    let frame_ms = u64::from(
        shared.mixer.lock().expect("mixer lock").frame_samples() as u32 * 1000 / SAMPLE_RATE,
    );
    let mut next_tick = Instant::now();

    while !stop.load(Ordering::Relaxed) {
        let due = if output_active {
            capacity - playback.slots() < lead
        } else {
            Instant::now() >= next_tick
        };
        if !due {
            std::thread::sleep(PUMP_INTERVAL);
            continue;
        }
        next_tick += Duration::from_millis(frame_ms);

        left.clear();
        right.clear();
        {
            let now = shared.now_ms();
            let mut renderer = shared.renderer.lock().expect("renderer lock");
            let mut mixer = shared.mixer.lock().expect("mixer lock");
            match mixer.render(renderer.as_mut(), now) {
                Ok(out) => {
                    left_rs.process(&out.left, &mut left);
                    right_rs.process(&out.right, &mut right);
                }
                Err(e) => debug!(error = %e, "mixing failed"),
            }
        }
        if output_active {
            interleaved.clear();
            interleaved.extend(left.iter().zip(&right).flat_map(|(l, r)| [*l, *r]));
            let _ = playback.push_partial_slice(&interleaved);
        }
    }
}
