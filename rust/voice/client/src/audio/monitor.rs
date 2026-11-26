//! Microphone level metering without a connection (e.g. for a mic test before joining).

use std::{
    sync::{
        Arc,
        atomic::{AtomicBool, AtomicU32, Ordering},
    },
    thread::JoinHandle,
};

use acre2_voice_codec::FRAME_SAMPLES;

use super::{
    activation::level_db,
    denoise::{Denoiser, NoiseConfig},
    device::{DeviceCallback, Devices, PUMP_INTERVAL},
};

/// Measures the microphone level, frame by frame. Dropping it closes the microphone.
pub struct MicMonitor {
    level_bits: Arc<AtomicU32>,
    stop: Arc<AtomicBool>,
    thread: Option<JoinHandle<()>>,
    _devices: Devices,
}

impl std::fmt::Debug for MicMonitor {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("MicMonitor")
            .field("level_db", &self.level_db())
            .finish()
    }
}

impl MicMonitor {
    /// Opens the named microphone (or the default). With noise suppression on, levels are
    /// measured after it, as the transmitter would see them.
    #[must_use]
    pub fn start(input: Option<String>, events: DeviceCallback, noise: NoiseConfig) -> Self {
        let (devices, mut capture) = Devices::open_input(input, events);
        let level_bits = Arc::new(AtomicU32::new((-100.0f32).to_bits()));
        let stop = Arc::new(AtomicBool::new(false));
        let thread = std::thread::Builder::new()
            .name("acre2-voice-meter".into())
            .spawn({
                let (level_bits, stop) = (level_bits.clone(), stop.clone());
                move || {
                    let mut buf: Vec<f32> = Vec::with_capacity(FRAME_SAMPLES * 4);
                    let mut denoiser = noise.suppress.then(Denoiser::new);
                    while !stop.load(Ordering::Relaxed) {
                        if let Ok(chunk) = capture.read_chunk(capture.slots()) {
                            let (a, b) = chunk.as_slices();
                            buf.extend_from_slice(a);
                            buf.extend_from_slice(b);
                            chunk.commit_all();
                        }
                        while buf.len() >= FRAME_SAMPLES {
                            let frame = &mut buf[..FRAME_SAMPLES];
                            if let Some(d) = &mut denoiser {
                                d.process(frame, true);
                            }
                            level_bits.store(level_db(frame).to_bits(), Ordering::Relaxed);
                            buf.drain(..FRAME_SAMPLES);
                        }
                        std::thread::sleep(PUMP_INTERVAL);
                    }
                }
            })
            .expect("spawning meter thread");
        Self {
            level_bits,
            stop,
            thread: Some(thread),
            _devices: devices,
        }
    }

    /// Level of the latest 20 ms frame in dBFS (−100 when silent).
    #[must_use]
    pub fn level_db(&self) -> f32 {
        f32::from_bits(self.level_bits.load(Ordering::Relaxed))
    }
}

impl Drop for MicMonitor {
    fn drop(&mut self) {
        self.stop.store(true, Ordering::Relaxed);
        if let Some(t) = self.thread.take() {
            let _ = t.join();
        }
    }
}
