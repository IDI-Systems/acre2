//! Test harness: an in-process voice server with a connected authority, and helpers for
//! joining clients and waiting on events.

pub mod signals;

use std::time::Duration;

use acre2_voice_client::{Authority, AuthorityEvent, Client, ClientEvent};
use acre2_voice_proto::{ServerMsg, Vec3, WorldUpdate, datagram::ServerVoice};
use acre2_voice_server::{Config, Identity, Server};
use tokio::sync::mpsc;

pub const SECRET: &str = "test-secret-123";
pub const WAIT: Duration = Duration::from_secs(5);

/// Installs a log subscriber once; honours `RUST_LOG`.
pub fn init_logging() {
    let _ = tracing_subscriber::fmt()
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .with_test_writer()
        .try_init();
}

/// A server on a random localhost port with a connected authority.
#[derive(Debug)]
pub struct Harness {
    pub server: Server,
    pub addr: String,
    pub fingerprint: [u8; 32],
    pub authority: Authority,
    pub authority_events: mpsc::Receiver<AuthorityEvent>,
}

impl Harness {
    pub async fn start() -> anyhow::Result<Self> {
        Self::with_config(|_| {}).await
    }

    pub async fn with_config(edit: impl FnOnce(&mut Config)) -> anyhow::Result<Self> {
        init_logging();
        let mut config = Config::new(SECRET);
        config.bind = "127.0.0.1:0".parse()?;
        config.reresolve_interval = Duration::from_millis(50);
        edit(&mut config);
        let identity = Identity::generate()?;
        let server = Server::start(config, &identity)?;
        let addr = server.local_addr()?.to_string();
        let fingerprint = server.fingerprint();
        let (authority, authority_events) =
            Authority::connect(&addr, Some(fingerprint), SECRET).await?;
        Ok(Self {
            server,
            addr,
            fingerprint,
            authority,
            authority_events,
        })
    }

    /// Issues a token and joins a client as `external_id`.
    pub async fn join(&self, external_id: &str) -> anyhow::Result<Bot> {
        let issued = self.authority.issue_token(external_id).await?;
        let (client, events) = Client::connect(&self.addr, self.fingerprint, issued.token).await?;
        Ok(Bot { client, events })
    }

    /// Sets positions and waits until the server has applied them.
    pub async fn place(&self, players: &[(&str, Vec3)]) -> anyhow::Result<()> {
        self.authority.update_world(
            players
                .iter()
                .map(|(id, position)| WorldUpdate {
                    external_id: (*id).to_string(),
                    position: *position,
                    active: true,
                })
                .collect(),
        )?;
        self.authority.ping().await?;
        Ok(())
    }

    pub async fn next_authority_event(&mut self) -> anyhow::Result<AuthorityEvent> {
        tokio::time::timeout(WAIT, self.authority_events.recv())
            .await?
            .ok_or_else(|| anyhow::anyhow!("authority events closed"))
    }
}

/// A joined client and its event stream.
#[derive(Debug)]
pub struct Bot {
    pub client: Client,
    pub events: mpsc::Receiver<ClientEvent>,
}

impl Bot {
    /// Next event of any kind.
    pub async fn next(&mut self) -> anyhow::Result<ClientEvent> {
        tokio::time::timeout(WAIT, self.events.recv())
            .await?
            .ok_or_else(|| anyhow::anyhow!("client events closed"))
    }

    /// Next control message, skipping voice.
    pub async fn next_message(&mut self) -> anyhow::Result<ServerMsg> {
        loop {
            match self.next().await? {
                ClientEvent::Message(m) => return Ok(m),
                ClientEvent::Voice(_) => {}
                ClientEvent::Closed { reason } => anyhow::bail!("closed: {reason}"),
            }
        }
    }

    /// Next voice frame, skipping control messages.
    pub async fn next_voice(&mut self) -> anyhow::Result<ServerVoice> {
        loop {
            match self.next().await? {
                ClientEvent::Voice(v) => return Ok(v),
                ClientEvent::Message(_) => {}
                ClientEvent::Closed { reason } => anyhow::bail!("closed: {reason}"),
            }
        }
    }

    /// Round trip through the server; everything this client sent before has been applied.
    pub async fn sync(&mut self) -> anyhow::Result<Vec<ServerMsg>> {
        let nonce = 0x5eed;
        self.client
            .send(acre2_voice_proto::ClientMsg::Ping { nonce })?;
        let mut before = Vec::new();
        loop {
            match self.next_message().await? {
                ServerMsg::Pong { nonce: n } if n == nonce => return Ok(before),
                other => before.push(other),
            }
        }
    }

    /// Asserts nothing arrives for a short while.
    pub async fn expect_silence(&mut self, wait: Duration) -> anyhow::Result<()> {
        match tokio::time::timeout(wait, self.events.recv()).await {
            Err(_) => Ok(()),
            Ok(event) => anyhow::bail!("expected nothing, got {event:?}"),
        }
    }
}
