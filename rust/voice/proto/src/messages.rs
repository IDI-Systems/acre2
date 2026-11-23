use serde::{Deserialize, Serialize};

use crate::{
    ChannelKey, ChannelRule, ExternalId, ExtraPosition, MatchedTarget, PeerId, Target, Token, TxId,
    Vec3,
};

/// Client → server, on the control stream.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum ClientMsg {
    /// Must be the first message.
    Hello {
        version: u16,
        token: Token,
    },
    /// Start (or replace) a transmission. Voice datagrams tagged with `tx` are routed to the
    /// recipients the targets resolve to. `metadata` is passed through to recipients untouched.
    StartTransmission {
        tx: TxId,
        targets: Vec<Target>,
        metadata: Vec<u8>,
    },
    StopTransmission {
        tx: TxId,
    },
    /// Replace the full set of channels this client receives.
    SetSubscriptions {
        channels: Vec<ChannelKey>,
    },
    /// Replace this client's extra positions. Ignored (with an error) unless the authority
    /// allows this peer to report positions. An empty list clears them.
    SetExtraPositions {
        positions: Vec<ExtraPosition>,
    },
    Ping {
        nonce: u64,
    },
}

/// Server → client, on the control stream.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum ServerMsg {
    Welcome {
        version: u16,
        peer_id: PeerId,
        external_id: ExternalId,
    },
    /// The hello was refused; the server closes the connection after sending this.
    Rejected {
        reason: String,
    },
    /// A transmission now reaches this client. Sent again with new `matched` targets when they
    /// change while the transmission is running.
    TransmissionStarted {
        speaker: PeerId,
        speaker_external_id: ExternalId,
        tx: TxId,
        matched: Vec<MatchedTarget>,
        metadata: Vec<u8>,
    },
    /// The transmission ended or no longer reaches this client.
    TransmissionEnded {
        speaker: PeerId,
        tx: TxId,
    },
    Pong {
        nonce: u64,
    },
    /// A request was refused; the connection stays open.
    Error {
        message: String,
    },
}

/// Authority → server, on the authority control stream.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum AuthorityMsg {
    /// Must be the first message.
    Hello {
        version: u16,
        secret: String,
    },
    /// Ask for a join token for a player. Answered with [`ServerToAuthorityMsg::Token`].
    IssueToken {
        request_id: u64,
        external_id: ExternalId,
    },
    /// Update the world state of some players. Players not mentioned keep their state.
    World {
        updates: Vec<WorldUpdate>,
    },
    /// Forget a player's world state, rules and permissions, and disconnect them.
    RemovePlayer {
        external_id: ExternalId,
    },
    /// Replace the channel rules for one player, or for everyone when `external_id` is `None`.
    /// A player's own rules are checked before the global ones.
    SetChannelRules {
        external_id: Option<ExternalId>,
        rules: Vec<ChannelRule>,
    },
    /// Allow or forbid a player to report extra positions. Revoking clears them.
    SetReportPosition {
        external_id: ExternalId,
        allowed: bool,
    },
    Ping {
        nonce: u64,
    },
}

/// One player's authoritative state.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct WorldUpdate {
    pub external_id: ExternalId,
    pub position: Vec3,
    /// Inactive players (dead, not yet spawned) neither emit nor hear spatial audio from their
    /// authority position. Extra positions still apply.
    pub active: bool,
}

/// Server → authority.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum ServerToAuthorityMsg {
    Welcome {
        version: u16,
        /// SHA-256 of the server's certificate (DER), for clients to pin.
        cert_fingerprint: [u8; 32],
        /// The address clients should connect to, if the server is configured with one.
        public_address: Option<String>,
    },
    Rejected {
        reason: String,
    },
    Token {
        request_id: u64,
        external_id: ExternalId,
        token: Token,
        expires_in_secs: u32,
    },
    PeerConnected {
        external_id: ExternalId,
        peer_id: PeerId,
    },
    PeerDisconnected {
        external_id: ExternalId,
        peer_id: PeerId,
    },
    Pong {
        nonce: u64,
    },
    Error {
        message: String,
    },
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::PositionRole;

    fn roundtrip<T>(msg: &T)
    where
        T: Serialize + for<'de> Deserialize<'de> + PartialEq + std::fmt::Debug,
    {
        let bytes = postcard::to_stdvec(msg).unwrap();
        let back: T = postcard::from_bytes(&bytes).unwrap();
        assert_eq!(&back, msg);
    }

    #[test]
    fn messages_roundtrip() {
        roundtrip(&ClientMsg::StartTransmission {
            tx: TxId(3),
            targets: vec![
                Target::Spatial { range: 50.0 },
                Target::Channel(ChannelKey::new("radio:43.100").unwrap()),
            ],
            metadata: vec![1, 2, 3],
        });
        roundtrip(&ClientMsg::SetExtraPositions {
            positions: vec![ExtraPosition {
                position: [1.0, 2.0, 3.0],
                role: PositionRole::Both,
            }],
        });
        roundtrip(&ServerMsg::TransmissionStarted {
            speaker: PeerId(9),
            speaker_external_id: "7656".into(),
            tx: TxId(1),
            matched: vec![MatchedTarget::Spatial { distance: 4.5 }],
            metadata: vec![],
        });
        roundtrip(&AuthorityMsg::World {
            updates: vec![WorldUpdate {
                external_id: "7656".into(),
                position: [0.0; 3],
                active: true,
            }],
        });
        roundtrip(&ServerToAuthorityMsg::Welcome {
            version: crate::PROTOCOL_VERSION,
            cert_fingerprint: [7; 32],
            public_address: Some("voice.example.com:9987".into()),
        });
    }
}
