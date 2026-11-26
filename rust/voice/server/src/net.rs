//! QUIC endpoint and the core task.
//!
//! One **core task** owns the [`World`] and the token store and handles all control messages.
//! Every connection has its own task that reads its control stream and voice datagrams, plus a
//! writer task for outgoing control messages.
//!
//! Voice never goes through the core: after each change, the core publishes each speaker's
//! routes (`tx → recipient connections`) into an [`ArcSwap`] that the speaker's connection task
//! reads when forwarding datagrams.

use std::{
    collections::HashMap,
    net::SocketAddr,
    sync::{
        Arc,
        atomic::{AtomicU64, Ordering},
    },
    time::{Duration, Instant},
};

use acre2_voice_proto::{
    ALPN_AUTHORITY, ALPN_CLIENT, AuthorityMsg, ClientMsg, PROTOCOL_VERSION, PeerId, ServerMsg,
    ServerToAuthorityMsg, Token, TxId, datagram::ClientVoice, frame,
};
use anyhow::Context;
use arc_swap::ArcSwap;
use quinn::{Connection, RecvStream, SendStream, VarInt};
use serde::{Serialize, de::DeserializeOwned};
use tokio::{
    sync::{mpsc, oneshot},
    task::JoinHandle,
    time::timeout,
};
use tracing::{debug, info, warn};

use crate::{
    config::Config,
    identity::Identity,
    ratelimit::{
        CONTROL_BURST, CONTROL_PER_SEC, MAX_VOICE_PAYLOAD, TokenBucket, VOICE_BURST, VOICE_PER_SEC,
    },
    tokens::Tokens,
    world::{Outgoing, World},
};

const HELLO_TIMEOUT: Duration = Duration::from_secs(10);
const OUT_QUEUE: usize = 512;
const EVENT_QUEUE: usize = 4096;

/// QUIC application close codes.
pub mod close_code {
    pub const NORMAL: u32 = 0;
    pub const REJECTED: u32 = 1;
    pub const KICKED: u32 = 2;
    pub const REPLACED: u32 = 3;
    pub const PROTOCOL: u32 = 4;
    pub const SHUTDOWN: u32 = 5;
}

fn close(conn: &Connection, code: u32, reason: &str) {
    conn.close(VarInt::from_u32(code), reason.as_bytes());
}

type Routes = HashMap<TxId, Arc<[Connection]>>;

/// A running voice server.
#[derive(Debug)]
pub struct Server {
    endpoint: quinn::Endpoint,
    fingerprint: [u8; 32],
    core: JoinHandle<()>,
    accept: JoinHandle<()>,
}

impl Server {
    /// Binds the endpoint and starts serving.
    pub fn start(config: Config, identity: &Identity) -> anyhow::Result<Self> {
        config.validate()?;
        let endpoint = acre2_voice_net::bind(config.bind, Some(server_config(identity)?))
            .with_context(|| format!("binding {}", config.bind))?;
        let fingerprint = identity.fingerprint();
        info!(addr = %endpoint.local_addr()?, fingerprint = %identity.fingerprint_hex(), "voice server listening");

        let (events_tx, events_rx) = mpsc::channel(EVENT_QUEUE);
        let core = tokio::spawn(Core::new(config, fingerprint).run(events_rx));
        let accept = tokio::spawn(accept_loop(endpoint.clone(), events_tx));
        Ok(Self {
            endpoint,
            fingerprint,
            core,
            accept,
        })
    }

    /// Whether the server is still serving (its tasks haven't ended).
    #[must_use]
    pub fn is_running(&self) -> bool {
        !self.core.is_finished() && !self.accept.is_finished()
    }

    pub fn local_addr(&self) -> std::io::Result<SocketAddr> {
        self.endpoint.local_addr()
    }

    #[must_use]
    pub fn fingerprint(&self) -> [u8; 32] {
        self.fingerprint
    }

    /// Closes every connection and stops the server. The UDP socket is released once the closed
    /// connections have drained (a few round trips), normally before this returns; a caller
    /// rebinding the same port should still retry briefly.
    pub async fn shutdown(self) {
        self.endpoint.close(
            VarInt::from_u32(close_code::SHUTDOWN),
            b"server shutting down",
        );
        self.accept.abort();
        self.core.abort();
        let _ = self.accept.await;
        let _ = self.core.await;
        let _ = timeout(Duration::from_secs(3), self.endpoint.wait_idle()).await;
    }
}

fn transport_config() -> quinn::TransportConfig {
    let mut t = quinn::TransportConfig::default();
    t.max_idle_timeout(Some(
        Duration::from_secs(20)
            .try_into()
            .expect("valid idle timeout"),
    ));
    t.keep_alive_interval(Some(Duration::from_secs(5)));
    // One control stream per connection, opened by the client.
    t.max_concurrent_bidi_streams(1u32.into());
    t.max_concurrent_uni_streams(0u32.into());
    t
}

fn server_config(identity: &Identity) -> anyhow::Result<quinn::ServerConfig> {
    let provider = Arc::new(rustls::crypto::ring::default_provider());
    let mut crypto = rustls::ServerConfig::builder_with_provider(provider)
        .with_protocol_versions(&[&rustls::version::TLS13])?
        .with_no_client_auth()
        .with_single_cert(vec![identity.cert.clone()], identity.key_der())?;
    crypto.alpn_protocols = vec![ALPN_CLIENT.to_vec(), ALPN_AUTHORITY.to_vec()];
    let crypto = quinn::crypto::rustls::QuicServerConfig::try_from(crypto)?;
    let mut config = quinn::ServerConfig::with_crypto(Arc::new(crypto));
    config.transport_config(Arc::new(transport_config()));
    Ok(config)
}

// ---- events ---------------------------------------------------------------------------------

type Reply<T> = oneshot::Sender<Result<T, String>>;

enum Event {
    ClientHello {
        token: Token,
        conn: Connection,
        out: mpsc::Sender<ServerMsg>,
        routes: Arc<ArcSwap<Routes>>,
        reply: Reply<(PeerId, ServerMsg)>,
    },
    Client(PeerId, ClientMsg),
    ClientGone(PeerId),
    AuthorityHello {
        id: u64,
        secret: String,
        conn: Connection,
        out: mpsc::Sender<ServerToAuthorityMsg>,
        reply: Reply<ServerToAuthorityMsg>,
    },
    Authority(u64, AuthorityMsg),
    AuthorityGone(u64),
}

// ---- core -----------------------------------------------------------------------------------

struct PeerConn {
    conn: Connection,
    out: mpsc::Sender<ServerMsg>,
    routes: Arc<ArcSwap<Routes>>,
}

struct AuthorityConn {
    id: u64,
    conn: Connection,
    out: mpsc::Sender<ServerToAuthorityMsg>,
}

struct Core {
    config: Config,
    fingerprint: [u8; 32],
    world: World,
    tokens: Tokens,
    peers: HashMap<PeerId, PeerConn>,
    next_peer: u32,
    authority: Option<AuthorityConn>,
}

impl Core {
    fn new(config: Config, fingerprint: [u8; 32]) -> Self {
        Self {
            world: World::new(config.limits()),
            tokens: Tokens::new(config.token_ttl),
            config,
            fingerprint,
            peers: HashMap::new(),
            next_peer: 1,
            authority: None,
        }
    }

    async fn run(mut self, mut events: mpsc::Receiver<Event>) {
        let mut tick = tokio::time::interval(self.config.reresolve_interval);
        tick.set_missed_tick_behavior(tokio::time::MissedTickBehavior::Delay);
        loop {
            tokio::select! {
                ev = events.recv() => match ev {
                    Some(ev) => self.handle(ev),
                    None => break,
                },
                _ = tick.tick() => {
                    let out = self.world.reresolve_all();
                    self.dispatch(out);
                    self.tokens.prune(Instant::now());
                }
            }
            self.publish_routes();
        }
    }

    fn handle(&mut self, ev: Event) {
        match ev {
            Event::ClientHello {
                token,
                conn,
                out,
                routes,
                reply,
            } => {
                let result = self.client_hello(&token, conn, out, routes);
                let _ = reply.send(result);
            }
            Event::Client(peer, msg) => self.client_msg(peer, msg),
            Event::ClientGone(peer) => self.drop_peer(peer),
            Event::AuthorityHello {
                id,
                secret,
                conn,
                out,
                reply,
            } => {
                let result = self.authority_hello(id, &secret, conn, out);
                let _ = reply.send(result);
            }
            Event::Authority(id, msg) => {
                if self.authority.as_ref().is_some_and(|a| a.id == id) {
                    self.authority_msg(msg);
                }
            }
            Event::AuthorityGone(id) => {
                if self.authority.as_ref().is_some_and(|a| a.id == id) {
                    info!("authority disconnected");
                    self.authority = None;
                }
            }
        }
    }

    fn client_hello(
        &mut self,
        token: &Token,
        conn: Connection,
        out: mpsc::Sender<ServerMsg>,
        routes: Arc<ArcSwap<Routes>>,
    ) -> Result<(PeerId, ServerMsg), String> {
        let external_id = self
            .tokens
            .redeem(token, Instant::now())
            .ok_or_else(|| "invalid or expired token".to_string())?;
        if let Some(old) = self.world.peer_by_external(&external_id) {
            if let Some(pc) = self.peers.get(&old) {
                close(
                    &pc.conn,
                    close_code::REPLACED,
                    "replaced by a new connection",
                );
            }
            self.drop_peer(old);
        }
        if self.peers.len() >= self.config.max_peers {
            return Err("server is full".into());
        }
        let peer = PeerId(self.next_peer);
        self.next_peer = self.next_peer.wrapping_add(1).max(1);

        info!(%peer, %external_id, addr = %conn.remote_address(), "client joined");
        self.peers.insert(peer, PeerConn { conn, out, routes });
        self.world.add_peer(peer, external_id.clone());
        self.notify_authority(ServerToAuthorityMsg::PeerConnected {
            external_id: external_id.clone(),
            peer_id: peer,
        });
        // The new peer may be in range of transmissions already running.
        let out = self.world.reresolve_all();
        self.dispatch(out);
        Ok((
            peer,
            ServerMsg::Welcome {
                version: PROTOCOL_VERSION,
                peer_id: peer,
                external_id,
            },
        ))
    }

    fn client_msg(&mut self, peer: PeerId, msg: ClientMsg) {
        if !self.peers.contains_key(&peer) {
            return;
        }
        let error = match msg {
            ClientMsg::Hello { .. } => Some("already joined".to_string()),
            ClientMsg::StartTransmission {
                tx,
                targets,
                metadata,
            } => {
                let (out, error) = self.world.start_transmission(peer, tx, targets, metadata);
                self.dispatch(out);
                error
            }
            ClientMsg::StopTransmission { tx } => {
                let out = self.world.stop_transmission(peer, tx);
                self.dispatch(out);
                None
            }
            ClientMsg::SetSubscriptions { channels } => {
                let (out, error) = self.world.set_subscriptions(peer, channels);
                self.dispatch(out);
                error
            }
            ClientMsg::SetExtraPositions { positions } => {
                self.world.set_extra_positions(peer, positions).err()
            }
            ClientMsg::Ping { nonce } => {
                self.send(peer, ServerMsg::Pong { nonce });
                None
            }
        };
        if let Some(message) = error {
            debug!(%peer, %message, "client request refused");
            self.send(peer, ServerMsg::Error { message });
        }
    }

    fn authority_hello(
        &mut self,
        id: u64,
        secret: &str,
        conn: Connection,
        out: mpsc::Sender<ServerToAuthorityMsg>,
    ) -> Result<ServerToAuthorityMsg, String> {
        if !constant_time_eq(secret.as_bytes(), self.config.authority_secret.as_bytes()) {
            warn!(addr = %conn.remote_address(), "authority presented a wrong secret");
            return Err("wrong secret".into());
        }
        if let Some(old) = self.authority.take() {
            close(
                &old.conn,
                close_code::REPLACED,
                "replaced by a new authority",
            );
        }
        info!(addr = %conn.remote_address(), "authority connected");
        // Bring the (possibly reconnecting) authority up to date. Queued behind the welcome.
        for peer in self.peers.keys() {
            if let Some(external_id) = self.world.external_id(*peer) {
                let _ = out.try_send(ServerToAuthorityMsg::PeerConnected {
                    external_id: external_id.to_string(),
                    peer_id: *peer,
                });
            }
        }
        self.authority = Some(AuthorityConn { id, conn, out });
        Ok(ServerToAuthorityMsg::Welcome {
            version: PROTOCOL_VERSION,
            cert_fingerprint: self.fingerprint,
            public_address: self.config.public_address.clone(),
        })
    }

    fn authority_msg(&mut self, msg: AuthorityMsg) {
        match msg {
            AuthorityMsg::Hello { .. } => self.notify_authority(ServerToAuthorityMsg::Error {
                message: "already authenticated".into(),
            }),
            AuthorityMsg::IssueToken {
                request_id,
                external_id,
            } => {
                let token = self.tokens.issue(external_id.clone(), Instant::now());
                self.notify_authority(ServerToAuthorityMsg::Token {
                    request_id,
                    external_id,
                    token,
                    expires_in_secs: self.tokens.ttl().as_secs() as u32,
                });
            }
            AuthorityMsg::World { updates } => self.world.apply_world(updates),
            AuthorityMsg::RemovePlayer { external_id } => {
                self.tokens.revoke(&external_id);
                if let Some(peer) = self.world.remove_player(&external_id) {
                    if let Some(pc) = self.peers.get(&peer) {
                        close(&pc.conn, close_code::KICKED, "removed by the game server");
                    }
                    self.drop_peer(peer);
                }
            }
            AuthorityMsg::SetChannelRules { external_id, rules } => {
                let out = self.world.set_rules(external_id, rules);
                self.dispatch(out);
            }
            AuthorityMsg::SetReportPosition {
                external_id,
                allowed,
            } => self.world.set_report_position(external_id, allowed),
            AuthorityMsg::Ping { nonce } => {
                self.notify_authority(ServerToAuthorityMsg::Pong { nonce });
            }
        }
    }

    fn drop_peer(&mut self, peer: PeerId) {
        let Some(pc) = self.peers.remove(&peer) else {
            return;
        };
        let external_id = self.world.external_id(peer).map(str::to_string);
        let out = self.world.remove_peer(peer);
        self.dispatch(out);
        pc.routes.store(Arc::default());
        if let Some(external_id) = external_id {
            info!(%peer, %external_id, "client left");
            self.notify_authority(ServerToAuthorityMsg::PeerDisconnected {
                external_id,
                peer_id: peer,
            });
        }
    }

    fn send(&mut self, peer: PeerId, msg: ServerMsg) {
        self.dispatch(vec![(peer, msg)]);
    }

    fn dispatch(&mut self, out: Vec<Outgoing>) {
        let mut too_slow = Vec::new();
        for (peer, msg) in out {
            if let Some(pc) = self.peers.get(&peer)
                && pc.out.try_send(msg).is_err()
            {
                too_slow.push(peer);
            }
        }
        for peer in too_slow {
            if let Some(pc) = self.peers.get(&peer) {
                warn!(%peer, "client is not reading control messages; disconnecting");
                close(&pc.conn, close_code::KICKED, "too slow");
            }
            self.drop_peer(peer);
        }
    }

    fn notify_authority(&mut self, msg: ServerToAuthorityMsg) {
        if let Some(a) = &self.authority
            && a.out.try_send(msg).is_err()
        {
            warn!("authority is not reading messages; disconnecting it");
            close(&a.conn, close_code::KICKED, "too slow");
            self.authority = None;
        }
    }

    fn publish_routes(&mut self) {
        for speaker in self.world.take_dirty_routes() {
            let Some(pc) = self.peers.get(&speaker) else {
                continue;
            };
            let routes: Routes = self
                .world
                .routes(speaker)
                .into_iter()
                .map(|(tx, recipients)| {
                    let conns: Arc<[Connection]> = recipients
                        .iter()
                        .filter_map(|r| self.peers.get(r).map(|p| p.conn.clone()))
                        .collect();
                    (tx, conns)
                })
                .collect();
            pc.routes.store(Arc::new(routes));
        }
    }
}

fn constant_time_eq(a: &[u8], b: &[u8]) -> bool {
    a.len() == b.len() && a.iter().zip(b).fold(0u8, |acc, (x, y)| acc | (x ^ y)) == 0
}

// ---- connections ----------------------------------------------------------------------------

/// Accepts connections. Each runs in a task owned by this loop, so aborting the loop (on
/// shutdown) also ends every connection's task and drops its handle, letting the endpoint
/// release its socket.
async fn accept_loop(endpoint: quinn::Endpoint, events: mpsc::Sender<Event>) {
    let mut connections = tokio::task::JoinSet::new();
    while let Some(incoming) = endpoint.accept().await {
        while connections.try_join_next().is_some() {}
        let events = events.clone();
        connections.spawn(async move {
            let conn = match incoming.await {
                Ok(conn) => conn,
                Err(e) => {
                    debug!(error = %e, "handshake failed");
                    return;
                }
            };
            let alpn = conn
                .handshake_data()
                .and_then(|h| h.downcast::<quinn::crypto::rustls::HandshakeData>().ok())
                .and_then(|h| h.protocol);
            match alpn.as_deref() {
                Some(ALPN_CLIENT) => run_client(conn, events).await,
                Some(ALPN_AUTHORITY) => run_authority(conn, events).await,
                _ => close(&conn, close_code::PROTOCOL, "unknown protocol"),
            }
        });
    }
}

/// Accepts the control stream and reads the hello message.
async fn accept_hello<T: DeserializeOwned>(
    conn: &Connection,
) -> anyhow::Result<(SendStream, RecvStream, T)> {
    let (send, mut recv) = timeout(HELLO_TIMEOUT, conn.accept_bi())
        .await
        .context("timed out waiting for control stream")??;
    let hello = timeout(HELLO_TIMEOUT, frame::read::<T, _>(&mut recv))
        .await
        .context("timed out waiting for hello")??
        .context("stream closed before hello")?;
    Ok((send, recv, hello))
}

/// Sends a rejection, then gives the peer a moment to read it before closing.
async fn reject<T: Serialize>(conn: &Connection, mut send: SendStream, msg: &T, reason: &str) {
    debug!(addr = %conn.remote_address(), %reason, "rejecting connection");
    if frame::write(&mut send, msg).await.is_ok() {
        let _ = send.finish();
        let _ = timeout(Duration::from_secs(2), conn.closed()).await;
    }
    close(conn, close_code::REJECTED, reason);
}

async fn writer<T: Serialize>(mut send: SendStream, mut rx: mpsc::Receiver<T>) {
    while let Some(msg) = rx.recv().await {
        if frame::write(&mut send, &msg).await.is_err() {
            break;
        }
    }
    let _ = send.finish();
}

async fn run_client(conn: Connection, events: mpsc::Sender<Event>) {
    let (mut send, mut recv, hello) = match accept_hello::<ClientMsg>(&conn).await {
        Ok(v) => v,
        Err(e) => {
            debug!(error = %e, "client hello failed");
            close(&conn, close_code::PROTOCOL, "bad hello");
            return;
        }
    };
    let token = match hello {
        ClientMsg::Hello { version, token } if version == PROTOCOL_VERSION => token,
        ClientMsg::Hello { version, .. } => {
            let reason =
                format!("protocol version {version} is not supported (server: {PROTOCOL_VERSION})");
            reject(
                &conn,
                send,
                &ServerMsg::Rejected {
                    reason: reason.clone(),
                },
                &reason,
            )
            .await;
            return;
        }
        _ => {
            close(&conn, close_code::PROTOCOL, "expected hello");
            return;
        }
    };

    let (out_tx, out_rx) = mpsc::channel(OUT_QUEUE);
    let routes: Arc<ArcSwap<Routes>> = Arc::default();
    let (reply_tx, reply_rx) = oneshot::channel();
    let hello = Event::ClientHello {
        token,
        conn: conn.clone(),
        out: out_tx,
        routes: routes.clone(),
        reply: reply_tx,
    };
    if events.send(hello).await.is_err() {
        return;
    }
    let (peer, welcome) = match reply_rx.await {
        Ok(Ok(v)) => v,
        Ok(Err(reason)) => {
            reject(
                &conn,
                send,
                &ServerMsg::Rejected {
                    reason: reason.clone(),
                },
                &reason,
            )
            .await;
            return;
        }
        Err(_) => return,
    };

    // The welcome goes first; everything the core queued meanwhile follows via the writer.
    if frame::write(&mut send, &welcome).await.is_ok() {
        let writer = tokio::spawn(writer(send, out_rx));
        let reason = tokio::select! {
            r = client_control_loop(&mut recv, peer, &events) => r,
            r = client_voice_loop(&conn, peer, &routes) => r,
        };
        debug!(%peer, ?reason, "client connection ended");
        if let Err(e) = &reason
            && e.to_string().contains("rate limit")
        {
            warn!(%peer, "client exceeded the control message rate limit; disconnecting");
            close(&conn, close_code::KICKED, "too many requests");
        }
        writer.abort();
    }
    let _ = events.send(Event::ClientGone(peer)).await;
}

async fn client_control_loop(
    recv: &mut RecvStream,
    peer: PeerId,
    events: &mpsc::Sender<Event>,
) -> anyhow::Result<()> {
    let mut bucket = TokenBucket::new(CONTROL_PER_SEC, CONTROL_BURST, Instant::now());
    while let Some(msg) = frame::read::<ClientMsg, _>(recv).await? {
        if !bucket.take(Instant::now()) {
            anyhow::bail!("control message rate limit exceeded");
        }
        events.send(Event::Client(peer, msg)).await?;
    }
    Ok(())
}

async fn client_voice_loop(
    conn: &Connection,
    peer: PeerId,
    routes: &ArcSwap<Routes>,
) -> anyhow::Result<()> {
    let mut bucket = TokenBucket::new(VOICE_PER_SEC, VOICE_BURST, Instant::now());
    loop {
        let data = conn.read_datagram().await?;
        if !bucket.take(Instant::now()) {
            continue;
        }
        let Ok(voice) = ClientVoice::decode(data) else {
            continue;
        };
        if voice.payload.len() > MAX_VOICE_PAYLOAD {
            continue;
        }
        let routes = routes.load();
        let Some(recipients) = routes.get(&voice.tx) else {
            continue;
        };
        let forwarded = voice.forward(peer).encode();
        for r in recipients.iter() {
            // Datagrams are best effort: a full buffer or a closed connection just drops it.
            let _ = r.send_datagram(forwarded.clone());
        }
    }
}

static NEXT_AUTHORITY: AtomicU64 = AtomicU64::new(1);

async fn run_authority(conn: Connection, events: mpsc::Sender<Event>) {
    let (mut send, mut recv, hello) = match accept_hello::<AuthorityMsg>(&conn).await {
        Ok(v) => v,
        Err(e) => {
            debug!(error = %e, "authority hello failed");
            close(&conn, close_code::PROTOCOL, "bad hello");
            return;
        }
    };
    let secret = match hello {
        AuthorityMsg::Hello { version, secret } if version == PROTOCOL_VERSION => secret,
        AuthorityMsg::Hello { version, .. } => {
            let reason =
                format!("protocol version {version} is not supported (server: {PROTOCOL_VERSION})");
            reject(
                &conn,
                send,
                &ServerToAuthorityMsg::Rejected {
                    reason: reason.clone(),
                },
                &reason,
            )
            .await;
            return;
        }
        _ => {
            close(&conn, close_code::PROTOCOL, "expected hello");
            return;
        }
    };

    let id = NEXT_AUTHORITY.fetch_add(1, Ordering::Relaxed);
    let (out_tx, out_rx) = mpsc::channel(OUT_QUEUE);
    let (reply_tx, reply_rx) = oneshot::channel();
    let hello = Event::AuthorityHello {
        id,
        secret,
        conn: conn.clone(),
        out: out_tx,
        reply: reply_tx,
    };
    if events.send(hello).await.is_err() {
        return;
    }
    let welcome = match reply_rx.await {
        Ok(Ok(v)) => v,
        Ok(Err(reason)) => {
            reject(
                &conn,
                send,
                &ServerToAuthorityMsg::Rejected {
                    reason: reason.clone(),
                },
                &reason,
            )
            .await;
            return;
        }
        Err(_) => return,
    };

    if frame::write(&mut send, &welcome).await.is_ok() {
        let writer = tokio::spawn(writer(send, out_rx));
        let result: anyhow::Result<()> = async {
            while let Some(msg) = frame::read::<AuthorityMsg, _>(&mut recv).await? {
                events.send(Event::Authority(id, msg)).await?;
            }
            Ok(())
        }
        .await;
        debug!(?result, "authority connection ended");
        writer.abort();
    }
    let _ = events.send(Event::AuthorityGone(id)).await;
}

#[cfg(test)]
mod tests {
    use super::constant_time_eq;

    #[test]
    fn ct_eq() {
        assert!(constant_time_eq(b"abc", b"abc"));
        assert!(!constant_time_eq(b"abc", b"abd"));
        assert!(!constant_time_eq(b"abc", b"abcd"));
    }
}
