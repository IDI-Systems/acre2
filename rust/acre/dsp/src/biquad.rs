//! Biquad filters with the coefficients of the DspFilters library ACRE2Core used
//! (Robert Bristow-Johnson's Audio EQ Cookbook), run in direct form II with `f64` state.

use std::f64::consts::PI;

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Biquad {
    b0: f64,
    b1: f64,
    b2: f64,
    a1: f64,
    a2: f64,
    v1: f64,
    v2: f64,
}

impl Biquad {
    fn new(a0: f64, a1: f64, a2: f64, b0: f64, b1: f64, b2: f64) -> Self {
        Self {
            b0: b0 / a0,
            b1: b1 / a0,
            b2: b2 / a0,
            a1: a1 / a0,
            a2: a2 / a0,
            v1: 0.0,
            v2: 0.0,
        }
    }

    #[must_use]
    pub fn lowpass(sample_rate: f64, cutoff: f64, q: f64) -> Self {
        let w0 = 2.0 * PI * cutoff / sample_rate;
        let (sn, cs) = w0.sin_cos();
        let al = sn / (2.0 * q);
        Self::new(
            1.0 + al,
            -2.0 * cs,
            1.0 - al,
            (1.0 - cs) / 2.0,
            1.0 - cs,
            (1.0 - cs) / 2.0,
        )
    }

    #[must_use]
    pub fn highpass(sample_rate: f64, cutoff: f64, q: f64) -> Self {
        let w0 = 2.0 * PI * cutoff / sample_rate;
        let (sn, cs) = w0.sin_cos();
        let al = sn / (2.0 * q);
        Self::new(
            1.0 + al,
            -2.0 * cs,
            1.0 - al,
            f64::midpoint(1.0, cs),
            -(1.0 + cs),
            f64::midpoint(1.0, cs),
        )
    }

    #[must_use]
    pub fn lowshelf(sample_rate: f64, cutoff: f64, gain_db: f64, shelf_slope: f64) -> Self {
        let a = 10f64.powf(gain_db / 40.0);
        let w0 = 2.0 * PI * cutoff / sample_rate;
        let (sn, cs) = w0.sin_cos();
        let al = sn / 2.0 * ((a + 1.0 / a) * (1.0 / shelf_slope - 1.0) + 2.0).sqrt();
        let sq = 2.0 * a.sqrt() * al;
        Self::new(
            (a + 1.0) + (a - 1.0) * cs + sq,
            -2.0 * ((a - 1.0) + (a + 1.0) * cs),
            (a + 1.0) + (a - 1.0) * cs - sq,
            a * ((a + 1.0) - (a - 1.0) * cs + sq),
            2.0 * a * ((a - 1.0) - (a + 1.0) * cs),
            a * ((a + 1.0) - (a - 1.0) * cs - sq),
        )
    }

    #[inline]
    pub fn tick(&mut self, x: f64) -> f64 {
        let w = x - self.a1 * self.v1 - self.a2 * self.v2;
        let y = self.b0 * w + self.b1 * self.v1 + self.b2 * self.v2;
        self.v2 = self.v1;
        self.v1 = w;
        y
    }

    pub fn process(&mut self, samples: &mut [f32]) {
        for s in samples {
            *s = self.tick(f64::from(*s)) as f32;
        }
    }

    pub fn reset(&mut self) {
        self.v1 = 0.0;
        self.v2 = 0.0;
    }
}

/// 4th-order Butterworth low-pass: two cookbook low-pass sections with the Butterworth Qs.
/// Same response as DspFilters' bilinear-transformed `Butterworth::LowPass<4>`.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Butterworth4 {
    sections: [Biquad; 2],
}

impl Butterworth4 {
    #[must_use]
    pub fn lowpass(sample_rate: f64, cutoff: f64) -> Self {
        // Q of each pole pair: 1 / (2 sin((2k - 1) π / 2n)), n = 4.
        let q = |k: f64| 1.0 / (2.0 * ((2.0 * k - 1.0) * PI / 8.0).sin());
        Self {
            sections: [
                Biquad::lowpass(sample_rate, cutoff, q(1.0)),
                Biquad::lowpass(sample_rate, cutoff, q(2.0)),
            ],
        }
    }

    #[inline]
    pub fn tick(&mut self, x: f64) -> f64 {
        let y = self.sections[0].tick(x);
        self.sections[1].tick(y)
    }

    pub fn process(&mut self, samples: &mut [f32]) {
        for s in samples {
            *s = self.tick(f64::from(*s)) as f32;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Steady-state gain at `freq`.
    fn gain(mut f: impl FnMut(f64) -> f64, freq: f64) -> f64 {
        let n = 48_000;
        let mut peak: f64 = 0.0;
        for i in 0..n {
            let y = f((2.0 * PI * freq * f64::from(i) / 48_000.0).sin());
            if i > n / 2 {
                peak = peak.max(y.abs());
            }
        }
        peak
    }

    fn db(g: f64) -> f64 {
        20.0 * g.log10()
    }

    #[test]
    fn lowpass_and_highpass_shapes() {
        let mut lp = Biquad::lowpass(48_000.0, 4000.0, 2.0);
        assert!((gain(|x| lp.tick(x), 200.0) - 1.0).abs() < 0.02);
        let mut lp = Biquad::lowpass(48_000.0, 4000.0, 2.0);
        assert!(db(gain(|x| lp.tick(x), 4000.0)) > 5.0, "Q=2 resonance");
        let mut lp = Biquad::lowpass(48_000.0, 4000.0, 2.0);
        assert!(db(gain(|x| lp.tick(x), 16_000.0)) < -20.0);
        let mut hp = Biquad::highpass(48_000.0, 750.0, 0.97);
        assert!(db(gain(|x| hp.tick(x), 100.0)) < -30.0);
    }

    #[test]
    fn lowshelf_cuts_lows() {
        let mut s = Biquad::lowshelf(48_000.0, 1000.0, -10.0, 1.0);
        assert!((db(gain(|x| s.tick(x), 50.0)) + 10.0).abs() < 0.5);
        let mut s = Biquad::lowshelf(48_000.0, 1000.0, -10.0, 1.0);
        assert!(db(gain(|x| s.tick(x), 15_000.0)).abs() < 0.5);
    }

    #[test]
    fn butterworth_is_3db_at_cutoff() {
        let mut b = Butterworth4::lowpass(48_000.0, 2000.0);
        assert!((db(gain(|x| b.tick(x), 2000.0)) + 3.01).abs() < 0.2);
        let mut b = Butterworth4::lowpass(48_000.0, 2000.0);
        assert!(db(gain(|x| b.tick(x), 8000.0)) < -45.0);
    }
}
