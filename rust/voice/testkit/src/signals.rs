//! Deterministic test signals.

use std::f32::consts::TAU;

/// A voice-like signal: a pitched harmonic series shaped by vowel formants, with gentle pitch
/// and syllable-rate loudness movement. Opus treats it as speech (unlike a pure tone, which it
/// may code as music, without in-band FEC).
#[derive(Debug, Clone)]
pub struct SpeechLike {
    sample_rate: f32,
    t: f32,
    phase: f32,
    amplitude: f32,
}

const HARMONICS: usize = 40;
/// (centre Hz, bandwidth Hz) of an "ah" vowel.
const FORMANTS: [(f32, f32); 3] = [(730.0, 90.0), (1090.0, 110.0), (2440.0, 170.0)];

impl SpeechLike {
    #[must_use]
    pub fn new(sample_rate: u32, amplitude: f32) -> Self {
        Self {
            sample_rate: sample_rate as f32,
            t: 0.0,
            phase: 0.0,
            amplitude,
        }
    }

    fn formant_gain(freq: f32) -> f32 {
        FORMANTS
            .iter()
            .map(|(c, bw)| 1.0 / (1.0 + ((freq - c) / bw).powi(2)))
            .sum::<f32>()
            + 0.05
    }

    /// Fills `out` with the next samples.
    pub fn fill(&mut self, out: &mut [f32]) {
        for s in out {
            let f0 = 120.0 + 15.0 * (TAU * 0.7 * self.t).sin();
            self.phase = (self.phase + f0 / self.sample_rate).fract();
            let mut v = 0.0;
            for k in 1..=HARMONICS {
                let f = f0 * k as f32;
                if f > self.sample_rate / 2.0 {
                    break;
                }
                v += Self::formant_gain(f) / k as f32 * (TAU * self.phase * k as f32).sin();
            }
            let syllables = 0.8 + 0.2 * (TAU * 4.0 * self.t).sin();
            *s = self.amplitude * syllables * v * 0.6;
            self.t += 1.0 / self.sample_rate;
        }
    }

    /// The next `len` samples.
    pub fn next_frame(&mut self, len: usize) -> Vec<f32> {
        let mut v = vec![0.0; len];
        self.fill(&mut v);
        v
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn level_is_sane() {
        let mut s = SpeechLike::new(48_000, 0.3);
        let x = s.next_frame(48_000);
        let peak = x.iter().fold(0.0f32, |a, v| a.max(v.abs()));
        let rms = (x.iter().map(|v| v * v).sum::<f32>() / x.len() as f32).sqrt();
        assert!(peak < 1.0, "peak {peak}");
        assert!(rms > 0.02, "rms {rms}");
    }
}
