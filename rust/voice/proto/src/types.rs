use std::fmt;

use serde::{Deserialize, Serialize};

/// A position in world space, in metres. The server only uses it for distances, so the axis
/// convention is up to the game (ACRE sends Arma's ASL `[x, y, z]`).
pub type Vec3 = [f32; 3];

/// Squared Euclidean distance between two points.
#[must_use]
pub fn distance_sq(a: Vec3, b: Vec3) -> f32 {
    let dx = a[0] - b[0];
    let dy = a[1] - b[1];
    let dz = a[2] - b[2];
    dx * dx + dy * dy + dz * dz
}

/// Server-assigned id of a connected client, unique for the lifetime of the server process.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord, Serialize, Deserialize)]
pub struct PeerId(pub u32);

impl fmt::Display for PeerId {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "peer#{}", self.0)
    }
}

/// Speaker-chosen id of a transmission. Unique among one speaker's *active* transmissions;
/// a speaker may reuse an id after stopping it.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord, Serialize, Deserialize)]
pub struct TxId(pub u16);

/// The game's own identity for a player (ACRE: the Steam UID). Opaque to the voice server.
pub type ExternalId = String;

/// Maximum length in bytes of a [`ChannelKey`].
pub const MAX_CHANNEL_KEY_LEN: usize = 128;

/// Name of a non-spatial audio channel, e.g. `radio:43.100` or `intercom:123:crew`.
///
/// Keys are opaque to the server except for prefix matching in permissions.
#[derive(Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Serialize, Deserialize)]
#[serde(try_from = "String", into = "String")]
pub struct ChannelKey(String);

#[derive(Debug, thiserror::Error, PartialEq, Eq)]
pub enum ChannelKeyError {
    #[error("channel key is empty")]
    Empty,
    #[error("channel key is longer than {MAX_CHANNEL_KEY_LEN} bytes")]
    TooLong,
}

impl ChannelKey {
    pub fn new(key: impl Into<String>) -> Result<Self, ChannelKeyError> {
        let key = key.into();
        if key.is_empty() {
            Err(ChannelKeyError::Empty)
        } else if key.len() > MAX_CHANNEL_KEY_LEN {
            Err(ChannelKeyError::TooLong)
        } else {
            Ok(Self(key))
        }
    }

    #[must_use]
    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl TryFrom<String> for ChannelKey {
    type Error = ChannelKeyError;
    fn try_from(value: String) -> Result<Self, Self::Error> {
        Self::new(value)
    }
}

impl From<ChannelKey> for String {
    fn from(value: ChannelKey) -> Self {
        value.0
    }
}

impl fmt::Display for ChannelKey {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(&self.0)
    }
}

/// Who a transmission is aimed at.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum Target {
    /// Everyone with a listener position within `range` metres of the speaker's emitter
    /// position. The server clamps `range` to its configured maximum.
    Spatial { range: f32 },
    /// Everyone subscribed to the channel.
    Channel(ChannelKey),
}

/// Why a recipient receives a transmission. One recipient can match several targets.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum MatchedTarget {
    /// Matched a spatial target; `distance` is from the emitter to the nearest listener position.
    Spatial {
        distance: f32,
    },
    Channel(ChannelKey),
}

/// What a client-reported extra position is used for.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum PositionRole {
    /// Spatial transmissions are emitted from here instead of the authority position.
    Emitter,
    /// The peer also hears spatial transmissions from here.
    Listener,
    Both,
}

impl PositionRole {
    #[must_use]
    pub fn is_emitter(self) -> bool {
        matches!(self, Self::Emitter | Self::Both)
    }

    #[must_use]
    pub fn is_listener(self) -> bool {
        matches!(self, Self::Listener | Self::Both)
    }
}

/// A position reported by the client itself, e.g. a Zeus or spectator camera. Only accepted
/// while the authority allows the peer to report positions.
#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize)]
pub struct ExtraPosition {
    pub position: Vec3,
    pub role: PositionRole,
}

/// Single-use join token, issued by the server at the authority's request.
#[derive(Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct Token(pub [u8; 32]);

impl Token {
    /// Lowercase hex, the form handed to game scripts.
    #[must_use]
    pub fn to_hex(&self) -> String {
        use fmt::Write;
        self.0.iter().fold(String::with_capacity(64), |mut s, b| {
            let _ = write!(s, "{b:02x}");
            s
        })
    }

    #[must_use]
    pub fn from_hex(s: &str) -> Option<Self> {
        let bytes = s.as_bytes();
        if bytes.len() != 64 {
            return None;
        }
        let mut out = [0u8; 32];
        for (i, pair) in bytes.as_chunks::<2>().0.iter().enumerate() {
            let hi = (pair[0] as char).to_digit(16)?;
            let lo = (pair[1] as char).to_digit(16)?;
            out[i] = (hi * 16 + lo) as u8;
        }
        Some(Self(out))
    }
}

impl fmt::Debug for Token {
    // Never log a full token.
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Token({:02x}{:02x}…)", self.0[0], self.0[1])
    }
}

/// Access rule for channels whose key starts with `prefix`. The longest matching prefix wins;
/// without any match, access is allowed.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct ChannelRule {
    pub prefix: String,
    pub allow_tx: bool,
    pub allow_rx: bool,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn channel_key_validation() {
        assert_eq!(ChannelKey::new(""), Err(ChannelKeyError::Empty));
        assert_eq!(
            ChannelKey::new("x".repeat(MAX_CHANNEL_KEY_LEN + 1)),
            Err(ChannelKeyError::TooLong)
        );
        assert!(ChannelKey::new("radio:43.100").is_ok());
    }

    #[test]
    fn channel_key_rejected_on_decode() {
        let bytes = postcard::to_stdvec(&String::new()).unwrap();
        assert!(postcard::from_bytes::<ChannelKey>(&bytes).is_err());
    }

    #[test]
    fn token_hex_roundtrip() {
        let t = Token(core::array::from_fn(|i| (i * 7) as u8));
        let hex = t.to_hex();
        assert_eq!(hex.len(), 64);
        assert_eq!(Token::from_hex(&hex), Some(t));
        assert_eq!(Token::from_hex("zz"), None);
        assert_eq!(Token::from_hex(&"g".repeat(64)), None);
    }

    #[test]
    fn token_debug_is_redacted() {
        let t = Token([0xab; 32]);
        assert_eq!(format!("{t:?}"), "Token(abab…)");
    }
}
