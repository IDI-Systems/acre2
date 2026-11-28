//! acre2 voice server.
//!
//! Game-agnostic: it routes voice between clients by distance ([`Target::Spatial`]) and by named
//! channels ([`Target::Channel`]), using positions and permissions supplied by a trusted
//! authority (the game server). See `acre2_voice_proto` for the protocol.
//!
//! [`Target::Spatial`]: acre2_voice_proto::Target::Spatial
//! [`Target::Channel`]: acre2_voice_proto::Target::Channel

pub mod config;
pub mod identity;
mod net;
pub mod ratelimit;
pub mod rules;
pub mod tokens;
pub mod world;

pub use config::Config;
pub use identity::Identity;
pub use net::{Server, close_code};
