//! The authority (game server) connection to a voice server.

use std::{
    collections::HashMap,
    sync::{
        Arc, Mutex,
        atomic::{AtomicU64, Ordering},
    },
};

use acre2_voice_proto::{
    ALPN_AUTHORITY, AuthorityMsg, ChannelRule, ExternalId, PROTOCOL_VERSION, PeerId,
    ServerToAuthorityMsg, Token, WorldUpdate, frame,
};
use tokio::sync::{mpsc, oneshot};
use tracing::{debug, warn};

use crate::{Error, transport};

const EVENT_QUEUE: usize = 1024;
const OUT_QUEUE: usize = 1024;
const HANDSHAKE_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(10);

/// What the server told the authority when it connected.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AuthorityWelcome {
    /// Fingerprint for clients to pin.
    pub cert_fingerprint: [u8; 32],
    /// The address clients should use, if the server has one configured.
    pub public_address: Option<String>,
}

/// A join token for one player.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct IssuedToken {
    pub external_id: ExternalId,
    pub token: Token,
    pub expires_in_secs: u32,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum AuthorityEvent {
    PeerConnected {
        external_id: ExternalId,
        peer_id: PeerId,
    },
    PeerDisconnected {
        external_id: ExternalId,
        peer_id: PeerId,
    },
    Error {
        message: String,
    },
    /// The connection is gone; no further events follow.
    Closed {
        reason: String,
    },
}

#[derive(Debug, Default)]
struct PendingMaps {
    tokens: HashMap<u64, oneshot::Sender<IssuedToken>>,
    pings: HashMap<u64, oneshot::Sender<()>>,
}

type Pending = Arc<Mutex<PendingMaps>>;

/// A connected authority. Dropping it closes the connection.
#[derive(Debug)]
pub struct Authority {
    endpoint: quinn::Endpoint,
    conn: quinn::Connection,
    out: mpsc::Sender<AuthorityMsg>,
    welcome: AuthorityWelcome,
    pending: Pending,
    next_request: AtomicU64,
}

impl Authority {
    /// Connects and authenticates. With `fingerprint` set, the server's certificate is pinned;
    /// without it any certificate is accepted (and the secret could be intercepted).
    pub async fn connect(
        addr: &str,
        fingerprint: Option<[u8; 32]>,
        secret: &str,
    ) -> Result<(Self, mpsc::Receiver<AuthorityEvent>), Error> {
        if fingerprint.is_none() {
            warn!("connecting to the voice server without a pinned certificate fingerprint");
        }
        let (endpoint, conn, mut send, mut recv) =
            transport::connect(addr, fingerprint, ALPN_AUTHORITY).await?;
        frame::write(
            &mut send,
            &AuthorityMsg::Hello {
                version: PROTOCOL_VERSION,
                secret: secret.to_string(),
            },
        )
        .await?;
        let reply = tokio::time::timeout(
            HANDSHAKE_TIMEOUT,
            frame::read::<ServerToAuthorityMsg, _>(&mut recv),
        )
        .await
        .map_err(|_| Error::Timeout)??;
        let welcome = match reply {
            Some(ServerToAuthorityMsg::Welcome {
                cert_fingerprint,
                public_address,
                ..
            }) => AuthorityWelcome {
                cert_fingerprint,
                public_address,
            },
            Some(ServerToAuthorityMsg::Rejected { reason }) => {
                conn.close(0u32.into(), b"rejected");
                return Err(Error::Rejected(reason));
            }
            Some(other) => return Err(Error::Protocol(format!("expected welcome, got {other:?}"))),
            None => return Err(Error::Rejected("closed".into())),
        };
        debug!("authority connected to voice server");

        let (events_tx, events_rx) = mpsc::channel(EVENT_QUEUE);
        let (out_tx, mut out_rx) = mpsc::channel::<AuthorityMsg>(OUT_QUEUE);
        let pending: Pending = Arc::default();

        tokio::spawn(async move {
            while let Some(msg) = out_rx.recv().await {
                if frame::write(&mut send, &msg).await.is_err() {
                    break;
                }
            }
            let _ = send.finish();
        });

        tokio::spawn(read_loop(recv, conn.clone(), pending.clone(), events_tx));

        Ok((
            Self {
                endpoint,
                conn,
                out: out_tx,
                welcome,
                pending,
                next_request: AtomicU64::new(1),
            },
            events_rx,
        ))
    }

    #[must_use]
    pub fn welcome(&self) -> &AuthorityWelcome {
        &self.welcome
    }

    /// The address the authority reached the server at.
    #[must_use]
    pub fn remote_address(&self) -> std::net::SocketAddr {
        self.conn.remote_address()
    }

    pub fn send(&self, msg: AuthorityMsg) -> Result<(), Error> {
        self.out.try_send(msg).map_err(|e| match e {
            mpsc::error::TrySendError::Full(_) => Error::Backpressure,
            mpsc::error::TrySendError::Closed(_) => Error::Disconnected,
        })
    }

    /// Asks the server for a join token for a player.
    pub async fn issue_token(
        &self,
        external_id: impl Into<ExternalId>,
    ) -> Result<IssuedToken, Error> {
        let request_id = self.next_request.fetch_add(1, Ordering::Relaxed);
        let (tx, rx) = oneshot::channel();
        self.pending
            .lock()
            .expect("pending lock")
            .tokens
            .insert(request_id, tx);
        if let Err(e) = self.send(AuthorityMsg::IssueToken {
            request_id,
            external_id: external_id.into(),
        }) {
            self.pending
                .lock()
                .expect("pending lock")
                .tokens
                .remove(&request_id);
            return Err(e);
        }
        rx.await.map_err(|_| Error::Disconnected)
    }

    /// Round trip to the server. When it returns, the server has applied every message this
    /// authority sent before it.
    pub async fn ping(&self) -> Result<(), Error> {
        let nonce = self.next_request.fetch_add(1, Ordering::Relaxed);
        let (tx, rx) = oneshot::channel();
        self.pending
            .lock()
            .expect("pending lock")
            .pings
            .insert(nonce, tx);
        if let Err(e) = self.send(AuthorityMsg::Ping { nonce }) {
            self.pending
                .lock()
                .expect("pending lock")
                .pings
                .remove(&nonce);
            return Err(e);
        }
        rx.await.map_err(|_| Error::Disconnected)
    }

    pub fn update_world(&self, updates: Vec<WorldUpdate>) -> Result<(), Error> {
        self.send(AuthorityMsg::World { updates })
    }

    pub fn remove_player(&self, external_id: impl Into<ExternalId>) -> Result<(), Error> {
        self.send(AuthorityMsg::RemovePlayer {
            external_id: external_id.into(),
        })
    }

    pub fn set_channel_rules(
        &self,
        external_id: Option<ExternalId>,
        rules: Vec<ChannelRule>,
    ) -> Result<(), Error> {
        self.send(AuthorityMsg::SetChannelRules { external_id, rules })
    }

    pub fn set_report_position(
        &self,
        external_id: impl Into<ExternalId>,
        allowed: bool,
    ) -> Result<(), Error> {
        self.send(AuthorityMsg::SetReportPosition {
            external_id: external_id.into(),
            allowed,
        })
    }

    pub fn close(&self) {
        self.conn.close(0u32.into(), b"bye");
    }
}

impl Drop for Authority {
    fn drop(&mut self) {
        self.conn.close(0u32.into(), b"bye");
        self.endpoint.close(0u32.into(), b"bye");
    }
}

/// Answers pending requests and forwards everything else as events. Keeps reading even if the
/// event receiver is dropped, so token requests and pings still complete.
async fn read_loop(
    mut recv: quinn::RecvStream,
    conn: quinn::Connection,
    pending: Pending,
    events: mpsc::Sender<AuthorityEvent>,
) {
    while let Ok(Some(msg)) = frame::read::<ServerToAuthorityMsg, _>(&mut recv).await {
        let event = match msg {
            ServerToAuthorityMsg::Token {
                request_id,
                external_id,
                token,
                expires_in_secs,
            } => {
                let waiter = pending
                    .lock()
                    .expect("pending lock")
                    .tokens
                    .remove(&request_id);
                if let Some(waiter) = waiter {
                    let _ = waiter.send(IssuedToken {
                        external_id,
                        token,
                        expires_in_secs,
                    });
                }
                continue;
            }
            ServerToAuthorityMsg::Pong { nonce } => {
                let waiter = pending.lock().expect("pending lock").pings.remove(&nonce);
                if let Some(waiter) = waiter {
                    let _ = waiter.send(());
                }
                continue;
            }
            ServerToAuthorityMsg::PeerConnected {
                external_id,
                peer_id,
            } => AuthorityEvent::PeerConnected {
                external_id,
                peer_id,
            },
            ServerToAuthorityMsg::PeerDisconnected {
                external_id,
                peer_id,
            } => AuthorityEvent::PeerDisconnected {
                external_id,
                peer_id,
            },
            ServerToAuthorityMsg::Error { message } => AuthorityEvent::Error { message },
            ServerToAuthorityMsg::Welcome { .. } | ServerToAuthorityMsg::Rejected { .. } => {
                continue;
            }
        };
        let _ = events.send(event).await;
    }
    // Dropping the waiters fails outstanding requests with `Disconnected`.
    *pending.lock().expect("pending lock") = PendingMaps::default();
    let reason = transport::describe_close(&conn.closed().await);
    let _ = events.send(AuthorityEvent::Closed { reason }).await;
}
