//! Streaming mono resampler between the device rate and 48 kHz.
//!
//! Cubic (Catmull-Rom) interpolation: cheap, no latency beyond two samples, and clean enough for
//! speech. Most devices run at 48 kHz anyway, in which case this is a copy.

#[derive(Debug, Clone)]
pub struct Resampler {
    /// Input samples per output sample.
    step: f64,
    /// Position of the next output sample, relative to `history[1]`.
    pos: f64,
    /// The last three input samples before the current block.
    history: [f32; 3],
}

impl Resampler {
    #[must_use]
    pub fn new(from_hz: u32, to_hz: u32) -> Self {
        Self {
            step: f64::from(from_hz) / f64::from(to_hz),
            pos: 0.0,
            history: [0.0; 3],
        }
    }

    #[must_use]
    pub fn is_passthrough(&self) -> bool {
        (self.step - 1.0).abs() < f64::EPSILON
    }

    /// Resamples `input`, appending to `out`.
    pub fn process(&mut self, input: &[f32], out: &mut Vec<f32>) {
        if self.is_passthrough() {
            out.extend_from_slice(input);
            return;
        }
        // Sample at virtual index i, where index 0 is history[0].
        let at = |i: isize| -> f32 {
            if i < 3 {
                self.history[i.max(0) as usize]
            } else {
                input.get((i - 3) as usize).copied().unwrap_or(0.0)
            }
        };
        let available = input.len() as f64;
        // Need samples i-1..=i+2 around position 1 + pos (virtual index of history[1] is 1).
        while self.pos + 1.0 + 2.0 < available + 3.0 {
            let x = 1.0 + self.pos;
            let i = x.floor() as isize;
            let t = (x - x.floor()) as f32;
            let (p0, p1, p2, p3) = (at(i - 1), at(i), at(i + 1), at(i + 2));
            let v = p1
                + 0.5
                    * t
                    * (p2 - p0
                        + t * (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3
                            + t * (3.0 * (p1 - p2) + p3 - p0)));
            out.push(v);
            self.pos += self.step;
        }
        // Shift: the new history is the last three virtual samples.
        let total = input.len() + 3;
        let new_history = [
            at(total as isize - 3),
            at(total as isize - 2),
            at(total as isize - 1),
        ];
        self.history = new_history;
        self.pos -= input.len() as f64;
    }
}

/// Averages interleaved channels down to mono.
pub fn downmix(interleaved: &[f32], channels: usize, out: &mut Vec<f32>) {
    if channels <= 1 {
        out.extend_from_slice(interleaved);
        return;
    }
    let scale = 1.0 / channels as f32;
    out.extend(
        interleaved
            .chunks_exact(channels)
            .map(|frame| frame.iter().sum::<f32>() * scale),
    );
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sine(rate: u32, freq: f32, len: usize) -> Vec<f32> {
        (0..len)
            .map(|i| (2.0 * std::f32::consts::PI * freq * i as f32 / rate as f32).sin())
            .collect()
    }

    #[test]
    fn passthrough_copies() {
        let mut r = Resampler::new(48_000, 48_000);
        let mut out = Vec::new();
        r.process(&[1.0, 2.0], &mut out);
        assert_eq!(out, vec![1.0, 2.0]);
    }

    #[test]
    fn rate_conversion_keeps_length_and_shape() {
        for (from, to) in [
            (44_100, 48_000),
            (48_000, 44_100),
            (16_000, 48_000),
            (96_000, 48_000),
        ] {
            let mut r = Resampler::new(from, to);
            let input = sine(from, 440.0, from as usize); // 1 s
            let mut out = Vec::new();
            for chunk in input.chunks(441) {
                r.process(chunk, &mut out);
            }
            let expected = to as usize;
            assert!(
                (out.len() as isize - expected as isize).abs() <= 4,
                "{from}->{to}: {} samples",
                out.len()
            );
            // Same tone: 440 Hz is 880 zero crossings per second, and the amplitude is kept.
            let crossings = out
                .windows(2)
                .filter(|w| (w[0] < 0.0) != (w[1] < 0.0))
                .count();
            assert!(
                (crossings as isize - 880).abs() <= 3,
                "{from}->{to}: {crossings} crossings"
            );
            let rms = (out.iter().map(|v| v * v).sum::<f32>() / out.len() as f32).sqrt();
            assert!(
                (rms - std::f32::consts::FRAC_1_SQRT_2).abs() < 0.02,
                "{from}->{to}: rms {rms}"
            );
        }
    }

    #[test]
    fn downmix_averages() {
        let mut out = Vec::new();
        downmix(&[1.0, 0.0, 0.5, 0.5], 2, &mut out);
        assert_eq!(out, vec![0.5, 0.5]);
    }
}
