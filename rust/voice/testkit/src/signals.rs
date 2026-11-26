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

/// Typing on a mechanical keyboard: sharp clicks (a broadband snap with a ~4 kHz ring,
/// decaying over a few milliseconds) at irregular intervals of 80–200 ms.
#[derive(Debug, Clone)]
pub struct KeyboardClicks {
    sample_rate: f32,
    amplitude: f32,
    rng: u64,
    until_next: usize,
    /// Samples into the current click, if one is sounding.
    click: Option<usize>,
}

impl KeyboardClicks {
    #[must_use]
    pub fn new(sample_rate: u32, amplitude: f32) -> Self {
        Self {
            sample_rate: sample_rate as f32,
            amplitude,
            rng: 0x2545_F491_4F6C_DD1D,
            until_next: 0,
            click: None,
        }
    }

    fn random(&mut self) -> f32 {
        self.rng ^= self.rng << 13;
        self.rng ^= self.rng >> 7;
        self.rng ^= self.rng << 17;
        (self.rng >> 40) as f32 / 16_777_216.0
    }

    /// Fills `out` with the next samples.
    pub fn fill(&mut self, out: &mut [f32]) {
        for s in out {
            if self.until_next == 0 {
                self.click = Some(0);
                let gap = 0.08 + 0.12 * self.random();
                self.until_next = (gap * self.sample_rate) as usize;
            }
            self.until_next -= 1;
            *s = match self.click {
                Some(n) if (n as f32) < 0.012 * self.sample_rate => {
                    let t = n as f32 / self.sample_rate;
                    let decay = (-t / 0.002).exp();
                    let noise = self.random() * 2.0 - 1.0;
                    let ring = (TAU * 4_000.0 * t).sin();
                    self.click = Some(n + 1);
                    self.amplitude * decay * (0.6 * noise + 0.4 * ring)
                }
                _ => {
                    self.click = None;
                    0.0
                }
            };
        }
    }

    /// The next `len` samples.
    pub fn next_frame(&mut self, len: usize) -> Vec<f32> {
        let mut v = vec![0.0; len];
        self.fill(&mut v);
        v
    }
}

/// Steady background noise like a PC fan or air conditioning: low-frequency rumble with mains
/// hum (50 Hz and its third harmonic) and a little hiss.
#[derive(Debug, Clone)]
pub struct FanNoise {
    sample_rate: f32,
    amplitude: f32,
    rng: u64,
    lowpass: f32,
    t: f32,
}

impl FanNoise {
    #[must_use]
    pub fn new(sample_rate: u32, amplitude: f32) -> Self {
        Self {
            sample_rate: sample_rate as f32,
            amplitude,
            rng: 0x9E37_79B9_7F4A_7C15,
            lowpass: 0.0,
            t: 0.0,
        }
    }

    /// Fills `out` with the next samples.
    pub fn fill(&mut self, out: &mut [f32]) {
        for s in out {
            self.rng ^= self.rng << 13;
            self.rng ^= self.rng >> 7;
            self.rng ^= self.rng << 17;
            let white = (self.rng >> 40) as f32 / 8_388_608.0 - 1.0;
            self.lowpass += 0.05 * (white - self.lowpass);
            let hum = 0.3 * (TAU * 50.0 * self.t).sin() + 0.1 * (TAU * 150.0 * self.t).sin();
            *s = self.amplitude * (4.0 * self.lowpass + 0.5 * hum + 0.1 * white);
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
