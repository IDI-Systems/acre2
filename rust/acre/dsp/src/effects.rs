//! ACRE's mono effects, ported from ACRE2Core.
//!
//! ACRE2Core worked on TeamSpeak's 10 ms callback blocks ([`BLOCK`] samples), and some effects
//! restart per block (the babel carrier's phase, the radio's sample-and-hold). To sound the same,
//! callers pass frames of any length and the effects split them into [`BLOCK`]-sized pieces.
//!
//! Samples are `f32` in `[-1, 1]` where the original used `i16`.

use std::f64::consts::PI;

use crate::{
    SAMPLE_RATE,
    biquad::{Biquad, Butterworth4},
    noise::{PinkNoise, Rng, white},
};

/// TeamSpeak's playback callback size at 48 kHz.
pub const BLOCK: usize = 480;

fn for_blocks(samples: &mut [f32], mut f: impl FnMut(&mut [f32])) {
    for block in samples.chunks_mut(BLOCK) {
        f(block);
    }
}

/// Radio transmission sound: band-limiting, sample-and-hold distortion, ring modulation and
/// noise, all getting worse as signal quality drops. (`CFilterRadio`)
#[derive(Debug, Clone)]
pub struct RadioEffect {
    highpass: Biquad,
    lowpass: Biquad,
    lowshelf: Biquad,
    pink: PinkNoise,
    rng: Rng,
    ring_phase: f32,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct RadioParams {
    /// 0 (no signal: silence) to 1 (perfect).
    pub signal_quality: f32,
    /// Add hiss for weak signals. Off for intercom.
    pub noise: bool,
    /// A loudspeaker rather than a headset: cuts the lows.
    pub loudspeaker: bool,
}

impl Default for RadioEffect {
    fn default() -> Self {
        Self::new(Rng::from_time())
    }
}

impl RadioEffect {
    #[must_use]
    pub fn new(rng: Rng) -> Self {
        let sr = f64::from(SAMPLE_RATE);
        Self {
            highpass: Biquad::highpass(sr, 750.0, 0.97),
            lowpass: Biquad::lowpass(sr, 4000.0, 2.0),
            lowshelf: Biquad::lowshelf(sr, 1000.0, -10.0, 1.0),
            pink: PinkNoise::default(),
            rng,
            ring_phase: 0.0,
        }
    }

    pub fn process(&mut self, samples: &mut [f32], params: RadioParams) {
        for_blocks(samples, |b| self.process_block(b, params));
    }

    fn process_block(&mut self, buf: &mut [f32], p: RadioParams) {
        let value = p.signal_quality;
        if value <= 0.0 {
            buf.fill(0.0);
            return;
        }
        for s in buf.iter_mut() {
            *s *= 3.0;
        }
        if p.noise {
            let inverse = 1.25 - value;
            for s in buf.iter_mut() {
                let n = self.pink.tick(&mut self.rng) * (0.35 * inverse);
                *s = (*s + n) - (n * *s);
            }
            for s in buf.iter_mut() {
                *s += white(&mut self.rng) * (0.001 * inverse);
            }
        }
        self.ring_modulate(buf, value);
        foldback(buf, value);
        self.lowpass.process(buf);
        self.highpass.process(buf);
        if p.loudspeaker {
            self.lowshelf.process(buf);
        }
        for s in buf.iter_mut() {
            *s = s.clamp(-1.0, 1.0);
        }
    }

    fn ring_modulate(&mut self, buf: &mut [f32], value: f32) {
        let mix = (1.0 - value) * 0.20;
        for s in buf.iter_mut() {
            let multiple = *s * (self.ring_phase * std::f32::consts::FRAC_PI_2).sin();
            self.ring_phase += 90.0 / 48_000.0;
            if self.ring_phase > 1.0 {
                self.ring_phase = 0.0;
            }
            *s = *s * (1.0 - mix) + multiple * mix;
        }
    }
}

/// Sample-and-hold "decimation": every `divisor`-th sample is held for the next ones, with the
/// divisor rising as the signal weakens. Restarts at each block boundary, as the original did.
fn foldback(buf: &mut [f32], value: f32) {
    let div = 256.0 * value.powi(4) - 693.33 * value.powi(3) + 648.0 * value.powi(2)
        - 250.67 * value
        + 40.0;
    let divisor = (div as i32).max(5) as usize;
    for start in (0..buf.len()).step_by(divisor) {
        let held = buf[start];
        for s in buf.iter_mut().skip(start + 1).take(divisor - 1) {
            *s = held;
        }
    }
}

/// Makes speech in a language the listener doesn't understand unintelligible while keeping its
/// rhythm. (`CBabbelEffect`)
#[derive(Debug, Clone)]
pub struct BabbelEffect {
    lp1: Butterworth4,
    lp2: Butterworth4,
}

impl Default for BabbelEffect {
    fn default() -> Self {
        let sr = f64::from(SAMPLE_RATE);
        Self {
            lp1: Butterworth4::lowpass(sr, 5200.0 * 0.3),
            lp2: Butterworth4::lowpass(sr, 5200.0 * 0.5),
        }
    }
}

impl BabbelEffect {
    const VOLUME: f32 = 6.0;

    pub fn process(&mut self, samples: &mut [f32]) {
        for_blocks(samples, |buf| {
            let step = 1.4 * PI / (48_000.0 / 5_200.0);
            for (i, s) in buf.iter_mut().enumerate() {
                *s = (f64::from(*s) * (i as f64 * step).cos()) as f32;
            }
            self.lp1.process(buf);
            self.lp2.process(buf);
            for s in buf.iter_mut() {
                *s = (*s * Self::VOLUME).clamp(-1.0, 1.0);
            }
        });
    }
}

/// Volume with a linear ramp from the previous value across each call, so changes don't click.
/// Silence below 0.001. (`CVolumeEffect`)
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct VolumeEffect {
    previous: f32,
}

impl Default for VolumeEffect {
    fn default() -> Self {
        Self { previous: 1.0 }
    }
}

impl VolumeEffect {
    pub fn process(&mut self, samples: &mut [f32], volume: f32) {
        let previous = self.previous;
        self.previous = volume;
        if volume <= 0.001 {
            samples.fill(0.0);
            return;
        }
        let n = samples.len() as f32;
        let dif = volume - previous;
        for (i, s) in samples.iter_mut().enumerate() {
            let v = previous + dif * (i as f32 / n);
            *s = (*s * v).clamp(-1.0, 1.0);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn tone(len: usize, freq: f32, amp: f32) -> Vec<f32> {
        (0..len)
            .map(|i| amp * (2.0 * std::f32::consts::PI * freq * i as f32 / 48_000.0).sin())
            .collect()
    }

    fn rms(x: &[f32]) -> f32 {
        (x.iter().map(|v| v * v).sum::<f32>() / x.len() as f32).sqrt()
    }

    #[test]
    fn radio_silences_without_signal() {
        let mut r = RadioEffect::new(Rng::new(1));
        let mut x = tone(960, 1000.0, 0.3);
        r.process(
            &mut x,
            RadioParams {
                signal_quality: 0.0,
                noise: true,
                loudspeaker: false,
            },
        );
        assert!(x.iter().all(|s| *s == 0.0));
    }

    #[test]
    fn radio_band_limits() {
        // A 200 Hz tone is mostly removed; a 1.5 kHz tone passes.
        let p = RadioParams {
            signal_quality: 1.0,
            noise: false,
            loudspeaker: false,
        };
        let mut low = tone(9600, 200.0, 0.1);
        RadioEffect::new(Rng::new(1)).process(&mut low, p);
        let mut mid = tone(9600, 1500.0, 0.1);
        RadioEffect::new(Rng::new(1)).process(&mut mid, p);
        assert!(
            rms(&mid[4800..]) > 4.0 * rms(&low[4800..]),
            "{} vs {}",
            rms(&mid[4800..]),
            rms(&low[4800..])
        );
    }

    #[test]
    fn weak_signal_adds_noise() {
        let p = RadioParams {
            signal_quality: 0.2,
            noise: true,
            loudspeaker: false,
        };
        let mut silence = vec![0.0; 9600];
        RadioEffect::new(Rng::new(3)).process(&mut silence, p);
        assert!(rms(&silence) > 0.01, "{}", rms(&silence));
    }

    #[test]
    fn foldback_holds_samples() {
        let mut x: Vec<f32> = (0..12).map(|i| i as f32).collect();
        foldback(&mut x, 1.0); // divisor 5
        assert_eq!(
            x,
            vec![0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 5.0, 5.0, 5.0, 10.0, 10.0]
        );
    }

    #[test]
    fn babbel_shifts_high_frequencies_down() {
        // The ~3.6 kHz carrier moves a 3.4 kHz component down to ~240 Hz, below the low-passes.
        let mut x = tone(9600, 3400.0, 0.2);
        let orig = x.clone();
        BabbelEffect::default().process(&mut x);
        assert!(rms(&x[4800..]) > 0.05);
        let corr: f32 = x.iter().zip(&orig).map(|(a, b)| a * b).sum::<f32>()
            / (rms(&x) * rms(&orig) * x.len() as f32);
        assert!(corr.abs() < 0.5, "{corr}");
    }

    #[test]
    fn volume_ramps() {
        let mut v = VolumeEffect::default();
        let mut x = vec![1.0; 4];
        v.process(&mut x, 0.5);
        assert_eq!(x, vec![1.0, 0.875, 0.75, 0.625]);
        let mut x = vec![1.0; 2];
        v.process(&mut x, 0.5);
        assert_eq!(x, vec![0.5, 0.5]);
        let mut x = vec![1.0; 2];
        v.process(&mut x, 0.0);
        assert_eq!(x, vec![0.0, 0.0]);
    }
}
