//! acre2 voice client.
//!
//! - [`Client`]: a player's connection. Sends control messages and voice frames, and yields
//!   [`ClientEvent`]s (control messages, voice frames from other speakers).
//! - [`Authority`]: the game server's connection, which issues join tokens and feeds the world
//!   state.
//!
//! - [`audio`]: voice activation, encoding, mixing, and (with the `devices` feature) live
//!   capture and playback.

pub mod audio;
mod authority;
mod client;
mod transport;

pub use authority::{Authority, AuthorityEvent, AuthorityWelcome, IssuedToken};
pub use client::{Client, ClientEvent, ConnectionStats};
pub use transport::{fingerprint, parse_fingerprint};

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("could not resolve {0}")]
    Resolve(String),
    #[error("TLS setup failed: {0}")]
    Tls(String),
    #[error("connecting failed: {0}")]
    Connect(#[from] quinn::ConnectError),
    #[error("connection failed: {0}")]
    Connection(#[from] quinn::ConnectionError),
    #[error("the server refused the connection: {0}")]
    Rejected(String),
    #[error("protocol error: {0}")]
    Protocol(String),
    #[error("timed out")]
    Timeout,
    #[error("not connected")]
    Disconnected,
    #[error("too many queued messages")]
    Backpressure,
    #[error("could not send voice: {0}")]
    Datagram(String),
    #[error(transparent)]
    Frame(#[from] acre2_voice_proto::frame::FrameError),
    #[error(transparent)]
    Io(std::io::Error),
}

impl From<quinn::WriteError> for Error {
    fn from(e: quinn::WriteError) -> Self {
        Self::Io(e.into())
    }
}
