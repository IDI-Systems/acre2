//! Noise sources matching ACRE2Core's (which used MSVC `rand()`, range 0..=32767).

/// Small fast PRNG standing in for `rand()`.
#[derive(Debug, Clone)]
pub struct Rng(u64);

impl Rng {
    #[must_use]
    pub fn new(seed: u64) -> Self {
        Self(seed | 1)
    }

    /// Seeded from the clock, like the original's `srand(time(0))`.
    #[must_use]
    pub fn from_time() -> Self {
        let nanos = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .map_or(0, |d| d.as_nanos() as u64);
        Self::new(nanos)
    }

    /// Like MSVC `rand()`: uniform in `0..=32767`.
    pub fn rand(&mut self) -> u32 {
        // xorshift64*
        self.0 ^= self.0 >> 12;
        self.0 ^= self.0 << 25;
        self.0 ^= self.0 >> 27;
        ((self.0.wrapping_mul(0x2545_F491_4F6C_DD1D) >> 33) & 0x7fff) as u32
    }
}

const RAND_MAX: f32 = 32767.0;

/// Uniform white noise in about `[-1, 1)`.
pub fn white(rng: &mut Rng) -> f32 {
    const C1: f32 = 32767.0;
    const C2: f32 = 10923.0; // (int)(C1 / 3) + 1
    let r = rng.rand() as f32 / (RAND_MAX + 1.0);
    // The original sums the same random value three times.
    (2.0 * (3.0 * r * C2) - 3.0 * (C2 - 1.0)) / C1
}

/// Three-stage pink noise filter (Paul Kellet's economy method), as in ACRE2Core.
#[derive(Debug, Clone, Default)]
pub struct PinkNoise {
    state: [f32; 3],
}

impl PinkNoise {
    const A: [f32; 3] = [0.021_092_38, 0.071_134_78, 0.688_735_6];
    const P: [f32; 3] = [0.3190, 0.7756, 0.9613];

    pub fn tick(&mut self, rng: &mut Rng) -> f32 {
        const RMI2: f32 = 2.0 / RAND_MAX;
        let offset = Self::A.iter().sum::<f32>();
        for (state, p) in self.state.iter_mut().zip(Self::P) {
            let t = rng.rand() as f32;
            *state = p * (*state - t) + t;
        }
        (Self::A[0] * self.state[0] + Self::A[1] * self.state[1] + Self::A[2] * self.state[2])
            * RMI2
            - offset
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn white_is_centred_and_bounded() {
        let mut rng = Rng::new(1);
        let xs: Vec<f32> = (0..100_000).map(|_| white(&mut rng)).collect();
        let mean = xs.iter().sum::<f32>() / xs.len() as f32;
        assert!(mean.abs() < 0.01, "{mean}");
        assert!(xs.iter().all(|x| (-1.01..=1.01).contains(x)));
    }

    #[test]
    fn pink_is_centred() {
        let mut rng = Rng::new(7);
        let mut p = PinkNoise::default();
        let xs: Vec<f32> = (0..100_000).map(|_| p.tick(&mut rng)).collect();
        let mean = xs[1000..].iter().sum::<f32>() / (xs.len() - 1000) as f32;
        assert!(mean.abs() < 0.05, "{mean}");
    }
}
