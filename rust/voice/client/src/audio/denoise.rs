//! Microphone noise suppression and speech detection (RNNoise, via `nnnoiseless`).
//!
//! Runs on our own microphone before voice activation and encoding: background noise (fans,
//! hum, room tone) is removed before it's sent, and the speech probability lets voice
//! activation ignore loud non-speech such as keyboard clacks.

use nnnoiseless::DenoiseState;

/// What the microphone filter does. Off by default.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub struct NoiseConfig {
    /// Remove background noise from what's sent.
    pub suppress: bool,
    /// Voice activation only opens on sound that seems to be speech, not just loud enough.
    pub speech_gate: bool,
}

impl NoiseConfig {
    /// Both on.
    pub const ON: Self = Self {
        suppress: true,
        speech_gate: true,
    };

    /// Whether the filter has to run at all.
    #[must_use]
    pub fn active(self) -> bool {
        self.suppress || self.speech_gate
    }
}

/// RNNoise's frame: 10 ms at 48 kHz.
pub const CHUNK: usize = DenoiseState::FRAME_SIZE;

/// RNNoise works in 16-bit sample units.
const SCALE: f32 = 32_768.0;

/// Frame-by-frame noise suppressor. Frames must be a multiple of 10 ms (480 samples) at 48 kHz.
pub struct Denoiser {
    state: Box<DenoiseState<'static>>,
    input: [f32; CHUNK],
    output: [f32; CHUNK],
}

impl std::fmt::Debug for Denoiser {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Denoiser").finish_non_exhaustive()
    }
}

impl Default for Denoiser {
    fn default() -> Self {
        Self::new()
    }
}

impl Denoiser {
    #[must_use]
    pub fn new() -> Self {
        Self {
            state: DenoiseState::new(),
            input: [0.0; CHUNK],
            output: [0.0; CHUNK],
        }
    }

    /// Analyses `frame` and, with `suppress`, replaces it with the denoised audio (10 ms
    /// later: RNNoise's delay). Returns the highest speech probability (0–1) of its 10 ms
    /// chunks.
    pub fn process(&mut self, frame: &mut [f32], suppress: bool) -> f32 {
        debug_assert_eq!(frame.len() % CHUNK, 0, "frames must be whole 10 ms chunks");
        let mut speech = 0.0f32;
        for chunk in frame.as_chunks_mut::<CHUNK>().0 {
            for (i, s) in self.input.iter_mut().zip(chunk.iter()) {
                *i = s * SCALE;
            }
            speech = speech.max(self.state.process_frame(&mut self.output, &self.input));
            if suppress {
                for (s, o) in chunk.iter_mut().zip(self.output.iter()) {
                    *s = (o / SCALE).clamp(-1.0, 1.0);
                }
            }
        }
        speech
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Deterministic noise: white, or fan-like (low rumble with mains hum) when `fan`.
    fn noise(n: usize, amplitude: f32, seed: &mut u64, fan: bool) -> Vec<f32> {
        let mut lowpass = 0.0f32;
        (0..n)
            .map(|i| {
                *seed ^= *seed << 13;
                *seed ^= *seed >> 7;
                *seed ^= *seed << 17;
                let white = (*seed >> 40) as f32 / 8_388_608.0 - 1.0;
                if !fan {
                    return white * amplitude;
                }
                lowpass += 0.05 * (white - lowpass);
                let hum = (i as f32 * std::f32::consts::TAU * 50.0 / 48_000.0).sin();
                (4.0 * lowpass + 0.15 * hum + 0.1 * white) * amplitude
            })
            .collect()
    }

    fn energy(x: &[f32]) -> f64 {
        x.iter().map(|s| f64::from(s * s)).sum()
    }

    #[test]
    fn removes_steady_background_noise() {
        let mut d = Denoiser::new();
        let mut seed = 99;
        let (mut before, mut after) = (0.0, 0.0);
        // Four seconds to learn the noise, then one second measured.
        for i in 0..250 {
            let mut frame = noise(960, 0.01, &mut seed, true);
            let e = energy(&frame);
            let p = d.process(&mut frame, true);
            if i >= 200 {
                before += e;
                after += energy(&frame);
                assert!(p < 0.5, "fan noise isn't speech ({p})");
            }
        }
        let reduction = 10.0 * (before / after).log10();
        assert!(reduction > 20.0, "only {reduction:.1} dB quieter");
    }

    #[test]
    fn analysis_only_leaves_audio_alone() {
        let mut d = Denoiser::new();
        let mut seed = 7;
        let original = noise(960, 0.1, &mut seed, false);
        let mut frame = original.clone();
        let p = d.process(&mut frame, false);
        assert_eq!(frame, original);
        assert!((0.0..=1.0).contains(&p));
    }

    #[test]
    fn silence_stays_silent() {
        let mut d = Denoiser::new();
        let mut frame = vec![0.0; 960];
        let p = d.process(&mut frame, true);
        assert!(frame.iter().all(|s| *s == 0.0));
        assert!(p < 0.1);
    }
}
