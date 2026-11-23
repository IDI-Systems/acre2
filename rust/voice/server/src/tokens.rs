//! Single-use join tokens.

use std::{
    collections::HashMap,
    time::{Duration, Instant},
};

use acre2_voice_proto::{ExternalId, Token};

#[derive(Debug)]
pub struct Tokens {
    ttl: Duration,
    pending: HashMap<Token, (ExternalId, Instant)>,
}

impl Tokens {
    #[must_use]
    pub fn new(ttl: Duration) -> Self {
        Self {
            ttl,
            pending: HashMap::new(),
        }
    }

    #[must_use]
    pub fn ttl(&self) -> Duration {
        self.ttl
    }

    pub fn issue(&mut self, external_id: ExternalId, now: Instant) -> Token {
        let mut bytes = [0u8; 32];
        getrandom::fill(&mut bytes).expect("system RNG unavailable");
        let token = Token(bytes);
        self.pending.insert(token, (external_id, now + self.ttl));
        token
    }

    /// Consumes a token, returning who it was issued for if it's valid.
    pub fn redeem(&mut self, token: &Token, now: Instant) -> Option<ExternalId> {
        let (external_id, expires) = self.pending.remove(token)?;
        (now <= expires).then_some(external_id)
    }

    pub fn prune(&mut self, now: Instant) {
        self.pending.retain(|_, (_, expires)| now <= *expires);
    }

    /// Invalidates all of a player's outstanding tokens.
    pub fn revoke(&mut self, external_id: &str) {
        self.pending.retain(|_, (id, _)| id != external_id);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[allow(clippy::many_single_char_names)]
    fn single_use_and_expiry() {
        let now = Instant::now();
        let mut t = Tokens::new(Duration::from_secs(10));
        let a = t.issue("a".into(), now);
        assert_eq!(t.redeem(&a, now), Some("a".into()));
        assert_eq!(t.redeem(&a, now), None, "single use");

        let b = t.issue("b".into(), now);
        assert_eq!(t.redeem(&b, now + Duration::from_secs(11)), None, "expired");

        let c = t.issue("c".into(), now);
        t.prune(now + Duration::from_secs(11));
        assert_eq!(t.redeem(&c, now), None, "pruned");

        let d = t.issue("d".into(), now);
        t.revoke("d");
        assert_eq!(t.redeem(&d, now), None, "revoked");
    }
}
