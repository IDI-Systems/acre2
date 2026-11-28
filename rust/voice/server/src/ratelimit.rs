//! Token buckets to keep one client from flooding the server or other clients.

use std::time::Instant;

#[derive(Debug, Clone)]
pub struct TokenBucket {
    capacity: f64,
    tokens: f64,
    per_sec: f64,
    last: Instant,
}

impl TokenBucket {
    /// `per_sec` sustained, bursts up to `burst`.
    #[must_use]
    pub fn new(per_sec: f64, burst: f64, now: Instant) -> Self {
        Self {
            capacity: burst,
            tokens: burst,
            per_sec,
            last: now,
        }
    }

    /// Takes one token if available.
    pub fn take(&mut self, now: Instant) -> bool {
        let elapsed = now.saturating_duration_since(self.last).as_secs_f64();
        self.last = now;
        self.tokens = (self.tokens + elapsed * self.per_sec).min(self.capacity);
        if self.tokens >= 1.0 {
            self.tokens -= 1.0;
            true
        } else {
            false
        }
    }
}

/// Voice datagrams per client: enough for several transmissions at 50 frames/s.
pub const VOICE_PER_SEC: f64 = 250.0;
pub const VOICE_BURST: f64 = 100.0;
/// Opus never produces more than this per frame; anything bigger is dropped.
pub const MAX_VOICE_PAYLOAD: usize = 1275;
/// Control messages per client. Normal clients send a few per second.
pub const CONTROL_PER_SEC: f64 = 50.0;
pub const CONTROL_BURST: f64 = 200.0;

#[cfg(test)]
mod tests {
    use std::time::Duration;

    use super::*;

    #[test]
    fn bursts_then_refills() {
        let t0 = Instant::now();
        let mut b = TokenBucket::new(10.0, 3.0, t0);
        assert!(b.take(t0) && b.take(t0) && b.take(t0));
        assert!(!b.take(t0));
        assert!(b.take(t0 + Duration::from_millis(100)));
        assert!(!b.take(t0 + Duration::from_millis(100)));
        // Never exceeds the burst size, however long it waits.
        let later = t0 + Duration::from_secs(60);
        assert!((0..3).all(|_| b.take(later)));
        assert!(!b.take(later));
    }
}
