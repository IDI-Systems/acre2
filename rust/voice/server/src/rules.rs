//! Channel access rules: longest matching prefix wins, player rules before global rules,
//! allowed when nothing matches.

use acre2_voice_proto::{ChannelKey, ChannelRule};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Access {
    Tx,
    Rx,
}

fn longest_match<'a>(rules: &'a [ChannelRule], key: &str) -> Option<&'a ChannelRule> {
    rules
        .iter()
        .filter(|r| key.starts_with(r.prefix.as_str()))
        .max_by_key(|r| r.prefix.len())
}

/// Whether `access` to `key` is allowed given a player's own rules and the global rules.
#[must_use]
pub fn allowed(
    player: &[ChannelRule],
    global: &[ChannelRule],
    key: &ChannelKey,
    access: Access,
) -> bool {
    let key = key.as_str();
    match longest_match(player, key).or_else(|| longest_match(global, key)) {
        None => true,
        Some(rule) => match access {
            Access::Tx => rule.allow_tx,
            Access::Rx => rule.allow_rx,
        },
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn rule(prefix: &str, tx: bool, rx: bool) -> ChannelRule {
        ChannelRule {
            prefix: prefix.into(),
            allow_tx: tx,
            allow_rx: rx,
        }
    }

    fn key(s: &str) -> ChannelKey {
        ChannelKey::new(s).unwrap()
    }

    #[test]
    fn default_allows() {
        assert!(allowed(&[], &[], &key("radio:1"), Access::Tx));
    }

    #[test]
    fn longest_prefix_wins() {
        let global = [rule("god:", false, false), rule("god:admins", true, true)];
        assert!(!allowed(&[], &global, &key("god:all"), Access::Tx));
        assert!(allowed(&[], &global, &key("god:admins"), Access::Rx));
    }

    #[test]
    fn player_rules_override_global() {
        let global = [rule("zeus", false, false)];
        let player = [rule("zeus", true, true)];
        assert!(!allowed(&[], &global, &key("zeus"), Access::Tx));
        assert!(allowed(&player, &global, &key("zeus"), Access::Tx));
    }

    #[test]
    fn tx_and_rx_are_separate() {
        let global = [rule("spectator", false, true)];
        assert!(!allowed(&[], &global, &key("spectator"), Access::Tx));
        assert!(allowed(&[], &global, &key("spectator"), Access::Rx));
    }
}
