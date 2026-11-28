//! Audio devices via cpal.
//!
//! The streams live on a dedicated thread (cpal streams aren't `Send` on every platform). The
//! device callbacks only move samples through lock-free ring buffers:
//!
//! - capture: device → downmix → resample to 48 kHz → `capture` ring (mono)
//! - playback: `playback` ring (stereo, device rate, interleaved L/R) → device channels

use std::{sync::mpsc as std_mpsc, thread::JoinHandle, time::Duration};

use cpal::{
    FromSample, SampleFormat, SizedSample, StreamConfig,
    traits::{DeviceTrait, HostTrait, StreamTrait},
};
use rtrb::{Consumer, Producer, RingBuffer};
use tracing::{debug, warn};

use super::resample::{Resampler, downmix};
use acre2_voice_codec::SAMPLE_RATE;

/// An audio device. `id` is stable and unique; `name` is for people (and may repeat).
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AudioDevice {
    pub id: String,
    pub name: String,
}

/// The available input and output devices.
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct DeviceList {
    pub inputs: Vec<AudioDevice>,
    pub outputs: Vec<AudioDevice>,
    pub default_input: Option<AudioDevice>,
    pub default_output: Option<AudioDevice>,
}

fn device_name(d: &cpal::Device) -> Option<String> {
    d.description().ok().map(|desc| desc.name().to_string())
}

fn describe(d: &cpal::Device) -> Option<AudioDevice> {
    Some(AudioDevice {
        id: d.id().ok()?.to_string(),
        name: device_name(d)?,
    })
}

#[must_use]
pub fn list_devices() -> DeviceList {
    let host = cpal::default_host();
    DeviceList {
        inputs: host
            .input_devices()
            .map(|it| it.filter_map(|d| describe(&d)).collect())
            .unwrap_or_default(),
        outputs: host
            .output_devices()
            .map(|it| it.filter_map(|d| describe(&d)).collect())
            .unwrap_or_default(),
        default_input: host.default_input_device().as_ref().and_then(describe),
        default_output: host.default_output_device().as_ref().and_then(describe),
    }
}

/// Finds a device by id (from [`list_devices`]) or, failing that, by name; else the default.
fn find(wanted: Option<&str>, input: bool) -> Option<cpal::Device> {
    let host = cpal::default_host();
    if let Some(wanted) = wanted {
        let by_id = wanted
            .parse::<cpal::DeviceId>()
            .ok()
            .and_then(|id| host.device_by_id(&id));
        let found = by_id.or_else(|| {
            let mut devices: Box<dyn Iterator<Item = cpal::Device>> = if input {
                Box::new(host.input_devices().ok()?)
            } else {
                Box::new(host.output_devices().ok()?)
            };
            devices.find(|d| device_name(d).as_deref() == Some(wanted))
        });
        if found.is_some() {
            return found;
        }
        warn!(device = %wanted, input, "audio device not found, using the default");
    }
    if input {
        host.default_input_device()
    } else {
        host.default_output_device()
    }
}

/// Something went wrong with a device. The other direction keeps working.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum DeviceEvent {
    InputOpened { name: String, sample_rate: u32 },
    OutputOpened { name: String, sample_rate: u32 },
    InputError(String),
    OutputError(String),
}

/// Receives device events, from any thread.
pub type DeviceCallback = std::sync::Arc<dyn Fn(DeviceEvent) + Send + Sync>;

/// The ring buffers device threads exchange samples through.
#[derive(Debug)]
pub struct Rings {
    /// 48 kHz mono microphone samples.
    pub capture: Consumer<f32>,
    /// Interleaved stereo at `output_rate`.
    pub playback: Producer<f32>,
    /// The playback device's sample rate (48 kHz when there's no device).
    pub output_rate: u32,
    /// Whether a playback device is consuming `playback`. Without one, the caller must pace
    /// itself.
    pub output_active: bool,
}

enum Command {
    Stop,
}

/// Owns the device thread. Dropping it closes the devices.
#[derive(Debug)]
pub struct Devices {
    commands: std_mpsc::Sender<Command>,
    thread: Option<JoinHandle<()>>,
}

const CAPTURE_RING: usize = SAMPLE_RATE as usize; // 1 s
const PLAYBACK_RING_MS: usize = 500;

impl Devices {
    /// Opens the named devices (or the defaults) and returns the rings to feed them.
    pub fn open(
        input: Option<String>,
        output: Option<String>,
        events: DeviceCallback,
    ) -> (Self, Rings) {
        let (cmd_tx, cmd_rx) = std_mpsc::channel();
        let (setup_tx, setup_rx) = std_mpsc::channel();
        let thread = std::thread::Builder::new()
            .name("acre2-voice-devices".into())
            .spawn(move || {
                let (cap_prod, cap_cons) = RingBuffer::<f32>::new(CAPTURE_RING);
                let input_stream = open_input(input.as_deref(), cap_prod, &events);
                let output_device = find(output.as_deref(), false);
                let output_rate = output_device
                    .as_ref()
                    .and_then(|d| d.default_output_config().ok())
                    .map_or(SAMPLE_RATE, |c| c.sample_rate());
                let ring_len = output_rate as usize * 2 * PLAYBACK_RING_MS / 1000;
                let (play_prod, play_cons) = RingBuffer::<f32>::new(ring_len);
                let output_stream = output_device.and_then(|d| open_output(&d, play_cons, &events));
                let _ = setup_tx.send(Rings {
                    capture: cap_cons,
                    playback: play_prod,
                    output_rate,
                    output_active: output_stream.is_some(),
                });
                // Keep the streams alive until told to stop.
                let _ = cmd_rx.recv();
                drop(input_stream);
                drop(output_stream);
                debug!("audio devices closed");
            })
            .expect("spawning device thread");
        let rings = setup_rx.recv().expect("device thread sends its rings");
        (
            Self {
                commands: cmd_tx,
                thread: Some(thread),
            },
            rings,
        )
    }

    /// Opens only a microphone (for level metering), returning its 48 kHz mono ring.
    pub fn open_input(input: Option<String>, events: DeviceCallback) -> (Self, Consumer<f32>) {
        let (cmd_tx, cmd_rx) = std_mpsc::channel();
        let (setup_tx, setup_rx) = std_mpsc::channel();
        let thread = std::thread::Builder::new()
            .name("acre2-voice-mic".into())
            .spawn(move || {
                let (cap_prod, cap_cons) = RingBuffer::<f32>::new(CAPTURE_RING);
                let input_stream = open_input(input.as_deref(), cap_prod, &events);
                let _ = setup_tx.send(cap_cons);
                let _ = cmd_rx.recv();
                drop(input_stream);
            })
            .expect("spawning device thread");
        let capture = setup_rx.recv().expect("device thread sends its ring");
        (
            Self {
                commands: cmd_tx,
                thread: Some(thread),
            },
            capture,
        )
    }
}

impl Drop for Devices {
    fn drop(&mut self) {
        let _ = self.commands.send(Command::Stop);
        if let Some(t) = self.thread.take() {
            let _ = t.join();
        }
    }
}

fn open_input(
    name: Option<&str>,
    ring: Producer<f32>,
    events: &DeviceCallback,
) -> Option<cpal::Stream> {
    let fail = |msg: String| {
        warn!(%msg, "microphone unavailable");
        events(DeviceEvent::InputError(msg));
        None
    };
    let Some(device) = find(name, true) else {
        return fail("no input device".into());
    };
    let supported = match device.default_input_config() {
        Ok(c) => c,
        Err(e) => return fail(e.to_string()),
    };
    let config: StreamConfig = supported.config();
    let stream = match supported.sample_format() {
        SampleFormat::F32 => build_input::<f32>(&device, &config, ring, events.clone()),
        SampleFormat::I16 => build_input::<i16>(&device, &config, ring, events.clone()),
        SampleFormat::U16 => build_input::<u16>(&device, &config, ring, events.clone()),
        SampleFormat::I32 => build_input::<i32>(&device, &config, ring, events.clone()),
        other => return fail(format!("unsupported sample format {other}")),
    };
    match stream.and_then(|s| s.play().map(|()| s).map_err(|e| e.to_string())) {
        Ok(s) => {
            let name = device_name(&device).unwrap_or_default();
            debug!(%name, rate = config.sample_rate, channels = config.channels, "microphone opened");
            events(DeviceEvent::InputOpened {
                name,
                sample_rate: config.sample_rate,
            });
            Some(s)
        }
        Err(e) => fail(e),
    }
}

fn build_input<T>(
    device: &cpal::Device,
    config: &StreamConfig,
    mut ring: Producer<f32>,
    events: DeviceCallback,
) -> Result<cpal::Stream, String>
where
    T: SizedSample,
    f32: FromSample<T>,
{
    let channels = usize::from(config.channels);
    let mut resampler = Resampler::new(config.sample_rate, SAMPLE_RATE);
    let mut floats = Vec::new();
    let mut mono = Vec::new();
    let mut at_48k = Vec::new();
    device
        .build_input_stream::<T, _, _>(
            *config,
            move |data: &[T], _| {
                floats.clear();
                floats.extend(
                    data.iter()
                        .map(|s| <f32 as FromSample<T>>::from_sample_(*s)),
                );
                mono.clear();
                downmix(&floats, channels, &mut mono);
                at_48k.clear();
                resampler.process(&mono, &mut at_48k);
                // If the consumer stalls, drop the newest audio rather than block.
                let (_, _) = ring.push_partial_slice(&at_48k);
            },
            move |e| {
                events(DeviceEvent::InputError(e.to_string()));
            },
            None,
        )
        .map_err(|e| e.to_string())
}

fn open_output(
    device: &cpal::Device,
    ring: Consumer<f32>,
    events: &DeviceCallback,
) -> Option<cpal::Stream> {
    let fail = |msg: String| {
        warn!(%msg, "speakers unavailable");
        events(DeviceEvent::OutputError(msg));
        None
    };
    let supported = match device.default_output_config() {
        Ok(c) => c,
        Err(e) => return fail(e.to_string()),
    };
    let config: StreamConfig = supported.config();
    let stream = match supported.sample_format() {
        SampleFormat::F32 => build_output::<f32>(device, &config, ring, events.clone()),
        SampleFormat::I16 => build_output::<i16>(device, &config, ring, events.clone()),
        SampleFormat::U16 => build_output::<u16>(device, &config, ring, events.clone()),
        SampleFormat::I32 => build_output::<i32>(device, &config, ring, events.clone()),
        other => return fail(format!("unsupported sample format {other}")),
    };
    match stream.and_then(|s| s.play().map(|()| s).map_err(|e| e.to_string())) {
        Ok(s) => {
            let name = device_name(device).unwrap_or_default();
            debug!(%name, rate = config.sample_rate, channels = config.channels, "speakers opened");
            events(DeviceEvent::OutputOpened {
                name,
                sample_rate: config.sample_rate,
            });
            Some(s)
        }
        Err(e) => fail(e),
    }
}

fn build_output<T>(
    device: &cpal::Device,
    config: &StreamConfig,
    mut ring: Consumer<f32>,
    events: DeviceCallback,
) -> Result<cpal::Stream, String>
where
    T: SizedSample + FromSample<f32>,
{
    let channels = usize::from(config.channels);
    device
        .build_output_stream::<T, _, _>(
            *config,
            move |data: &mut [T], _| {
                for frame in data.chunks_mut(channels) {
                    // Underrun plays silence.
                    let l = ring.pop().unwrap_or(0.0);
                    let r = ring.pop().unwrap_or(0.0);
                    if frame.len() == 1 {
                        frame[0] = T::from_sample(f32::midpoint(l, r));
                    } else {
                        frame[0] = T::from_sample(l);
                        frame[1] = T::from_sample(r);
                        for extra in &mut frame[2..] {
                            *extra = T::from_sample(0.0f32);
                        }
                    }
                }
            },
            move |e| {
                events(DeviceEvent::OutputError(e.to_string()));
            },
            None,
        )
        .map_err(|e| e.to_string())
}

/// How long the playback thread sleeps between checks.
pub(crate) const PUMP_INTERVAL: Duration = Duration::from_millis(5);
