//! Player connection to a voice server.

use acre2_voice_proto::{
    ALPN_CLIENT, ChannelKey, ClientMsg, ExternalId, ExtraPosition, PROTOCOL_VERSION, PeerId,
    ServerMsg, Target, Token, TxId,
    datagram::{ClientVoice, ServerVoice},
    frame,
};
use bytes::Bytes;
use tokio::sync::mpsc;
use tracing::debug;

use crate::{Error, transport};

const EVENT_QUEUE: usize = 1024;
const OUT_QUEUE: usize = 256;
const HANDSHAKE_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(10);

/// Something that arrived from the server.
#[derive(Debug, Clone, PartialEq)]
pub enum ClientEvent {
    Message(ServerMsg),
    Voice(ServerVoice),
    /// The connection is gone; no further events follow.
    Closed {
        reason: String,
    },
}

/// A connected client. Dropping it closes the connection.
#[derive(Debug)]
pub struct Client {
    endpoint: quinn::Endpoint,
    conn: quinn::Connection,
    out: mpsc::Sender<ClientMsg>,
    peer_id: PeerId,
    external_id: ExternalId,
}

impl Client {
    /// Connects and joins with a token. `addr` is `host:port`.
    pub async fn connect(
        addr: &str,
        fingerprint: [u8; 32],
        token: Token,
    ) -> Result<(Self, mpsc::Receiver<ClientEvent>), Error> {
        let (endpoint, conn, mut send, mut recv) =
            transport::connect(addr, Some(fingerprint), ALPN_CLIENT).await?;
        frame::write(
            &mut send,
            &ClientMsg::Hello {
                version: PROTOCOL_VERSION,
                token,
            },
        )
        .await?;
        let reply = tokio::time::timeout(HANDSHAKE_TIMEOUT, frame::read::<ServerMsg, _>(&mut recv))
            .await
            .map_err(|_| Error::Timeout)??;
        let (peer_id, external_id) = match reply {
            Some(ServerMsg::Welcome {
                peer_id,
                external_id,
                ..
            }) => (peer_id, external_id),
            Some(ServerMsg::Rejected { reason }) => {
                conn.close(0u32.into(), b"rejected");
                return Err(Error::Rejected(reason));
            }
            Some(other) => return Err(Error::Protocol(format!("expected welcome, got {other:?}"))),
            None => {
                let reason = conn
                    .close_reason()
                    .map_or_else(|| "closed".to_string(), |e| transport::describe_close(&e));
                return Err(Error::Rejected(reason));
            }
        };
        debug!(%peer_id, %external_id, "joined voice server");

        let (events_tx, events_rx) = mpsc::channel(EVENT_QUEUE);
        let (out_tx, mut out_rx) = mpsc::channel::<ClientMsg>(OUT_QUEUE);

        tokio::spawn(async move {
            while let Some(msg) = out_rx.recv().await {
                if frame::write(&mut send, &msg).await.is_err() {
                    break;
                }
            }
            let _ = send.finish();
        });

        let reader_conn = conn.clone();
        tokio::spawn(async move {
            let control = async {
                while let Ok(Some(msg)) = frame::read::<ServerMsg, _>(&mut recv).await {
                    if events_tx.send(ClientEvent::Message(msg)).await.is_err() {
                        break;
                    }
                }
            };
            let voice = async {
                while let Ok(data) = reader_conn.read_datagram().await {
                    if let Ok(v) = ServerVoice::decode(data) {
                        // Late audio is useless: drop rather than block when the consumer lags.
                        let _ = events_tx.try_send(ClientEvent::Voice(v));
                    }
                }
            };
            tokio::select! {
                () = control => {},
                () = voice => {},
            }
            let reason = transport::describe_close(&reader_conn.closed().await);
            let _ = events_tx.send(ClientEvent::Closed { reason }).await;
        });

        Ok((
            Self {
                endpoint,
                conn,
                out: out_tx,
                peer_id,
                external_id,
            },
            events_rx,
        ))
    }

    #[must_use]
    pub fn peer_id(&self) -> PeerId {
        self.peer_id
    }

    #[must_use]
    pub fn external_id(&self) -> &str {
        &self.external_id
    }

    /// Queues a control message.
    pub fn send(&self, msg: ClientMsg) -> Result<(), Error> {
        self.out.try_send(msg).map_err(|e| match e {
            mpsc::error::TrySendError::Full(_) => Error::Backpressure,
            mpsc::error::TrySendError::Closed(_) => Error::Disconnected,
        })
    }

    pub fn start_transmission(
        &self,
        tx: TxId,
        targets: Vec<Target>,
        metadata: Vec<u8>,
    ) -> Result<(), Error> {
        self.send(ClientMsg::StartTransmission {
            tx,
            targets,
            metadata,
        })
    }

    pub fn stop_transmission(&self, tx: TxId) -> Result<(), Error> {
        self.send(ClientMsg::StopTransmission { tx })
    }

    pub fn set_subscriptions(&self, channels: Vec<ChannelKey>) -> Result<(), Error> {
        self.send(ClientMsg::SetSubscriptions { channels })
    }

    pub fn set_extra_positions(&self, positions: Vec<ExtraPosition>) -> Result<(), Error> {
        self.send(ClientMsg::SetExtraPositions { positions })
    }

    /// Sends one voice frame as an unreliable datagram.
    pub fn send_voice(&self, tx: TxId, seq: u16, flags: u8, payload: Bytes) -> Result<(), Error> {
        let data = ClientVoice {
            tx,
            seq,
            flags,
            payload,
        }
        .encode();
        self.conn.send_datagram(data).map_err(|e| match e {
            quinn::SendDatagramError::ConnectionLost(_) => Error::Disconnected,
            other => Error::Datagram(other.to_string()),
        })
    }

    /// Largest datagram the connection can currently carry, header included.
    #[must_use]
    pub fn max_datagram_size(&self) -> Option<usize> {
        self.conn.max_datagram_size()
    }

    /// Round-trip time estimate.
    #[must_use]
    pub fn rtt(&self) -> std::time::Duration {
        self.conn.rtt()
    }

    /// Transport statistics: round trip, packets sent and lost, bytes each way.
    #[must_use]
    pub fn stats(&self) -> ConnectionStats {
        let s = self.conn.stats();
        ConnectionStats {
            rtt: self.conn.rtt(),
            sent_packets: s.path.sent_packets,
            lost_packets: s.path.lost_packets,
            rx_bytes: s.udp_rx.bytes,
            tx_bytes: s.udp_tx.bytes,
        }
    }

    pub fn close(&self) {
        self.conn.close(0u32.into(), b"bye");
    }
}

/// See [`Client::stats`].
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
pub struct ConnectionStats {
    pub rtt: std::time::Duration,
    pub sent_packets: u64,
    /// Our packets the connection detected as lost (outgoing loss).
    pub lost_packets: u64,
    pub rx_bytes: u64,
    pub tx_bytes: u64,
}

impl Drop for Client {
    fn drop(&mut self) {
        self.conn.close(0u32.into(), b"bye");
        self.endpoint.close(0u32.into(), b"bye");
    }
}
