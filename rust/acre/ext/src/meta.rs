//! What ACRE attaches to each transmission (the voice server passes it through untouched).

use serde::{Deserialize, Serialize};

/// `SPEAKING_TYPE_*` from `main/script_macros.hpp`.
pub mod speaking_type {
    pub const DIRECT: u8 = 0;
    pub const RADIO: u8 = 1;
    pub const UNKNOWN: u8 = 2;
    pub const INTERCOM: u8 = 3;
    pub const SPECTATE: u8 = 4;
    pub const GOD: u8 = 5;
    pub const ZEUS: u8 = 6;
}

/// The fields of TS3-era `ext_remoteStartSpeaking`.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Meta {
    pub speaking_type: u8,
    pub radio_id: String,
    pub net_id: String,
    pub language_id: i32,
    /// The speaker's selectable voice curve scale (direct speech loudness).
    pub curve_scale: f32,
}

impl Meta {
    #[must_use]
    pub fn encode(&self) -> Vec<u8> {
        postcard::to_stdvec(self).unwrap_or_default()
    }

    #[must_use]
    pub fn decode(bytes: &[u8]) -> Option<Self> {
        postcard::from_bytes(bytes).ok()
    }

    /// Whether two announcements describe the same speaking state (only the curve scale may
    /// differ, which updates silently, as in ACRE2Core).
    #[must_use]
    pub fn same_state(&self, other: &Self) -> bool {
        self.speaking_type == other.speaking_type
            && self.radio_id == other.radio_id
            && self.net_id == other.net_id
            && self.language_id == other.language_id
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn roundtrip() {
        let m = Meta {
            speaking_type: speaking_type::RADIO,
            radio_id: "ACRE_PRC152_ID_1".into(),
            net_id: "2:345".into(),
            language_id: 1,
            curve_scale: 0.7,
        };
        assert_eq!(Meta::decode(&m.encode()), Some(m.clone()));
        assert_eq!(Meta::decode(b"garbage\xff\xff"), None);
        assert!(m.same_state(&Meta {
            curve_scale: 1.0,
            ..m.clone()
        }));
        assert!(!m.same_state(&Meta {
            radio_id: "other".into(),
            ..m.clone()
        }));
    }
}
