//! Wire protocol for the acre2 voice server.
//!
//! There are two kinds of connection to a voice server, told apart by QUIC ALPN:
//!
//! - **Clients** ([`ALPN_CLIENT`]) are players. They join with a single-use [`Token`], stream
//!   voice as unreliable datagrams ([`datagram`]) and exchange [`ClientMsg`]/[`ServerMsg`] on one
//!   reliable bidirectional stream.
//! - **The authority** ([`ALPN_AUTHORITY`]) is the trusted game server. It authenticates with a
//!   shared secret, issues tokens, and owns the world state (positions, permissions) through
//!   [`AuthorityMsg`]/[`ServerToAuthorityMsg`].
//!
//! Control messages are `postcard`-encoded and length-prefixed ([`frame`]).
//!
//! This crate is game-agnostic: channel keys and transmission metadata are opaque to it.

pub mod datagram;
pub mod frame;
mod messages;
mod types;

pub use messages::*;
pub use types::*;

/// Protocol version, checked in the hello handshake. Bump on any incompatible change.
pub const PROTOCOL_VERSION: u16 = 1;

/// ALPN for player connections.
pub const ALPN_CLIENT: &[u8] = b"acre2-voice/1";
/// ALPN for the authority (game server) connection.
pub const ALPN_AUTHORITY: &[u8] = b"acre2-authority/1";

/// Maximum size of one encoded control message, to bound memory on malformed input.
pub const MAX_FRAME_LEN: usize = 256 * 1024;
