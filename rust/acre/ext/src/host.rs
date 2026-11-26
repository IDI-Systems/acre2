//! The voice server, hosted inside the Arma server's extension.
//!
//! `["server:start", [port, address]]` binds the voice server on UDP `port` and connects to it
//! locally as its authority with a secret generated on the spot, so there is nothing to
//! configure or keep secret. `address` is where players connect (a public IP or hostname, with
//! or without `:port`).
//!
//! `ACRE2_VOICE_PORT` and `ACRE2_VOICE_ADDRESS` override the arguments.

use std::{
    net::{IpAddr, SocketAddr},
    sync::{Mutex, OnceLock},
    time::{Duration, Instant},
};

use acre2_voice_proto::Token;
use acre2_voice_server::{Config, Identity, Server};
use arma_rs::Group;

use crate::{authority, callback::emit, runtime};

/// The running server and what it was started with.
struct Hosted {
    server: Server,
    /// The port asked for (0: any).
    port: u16,
    /// The address asked for, as given.
    address: String,
    secret: String,
    fingerprint: String,
    client_address: String,
}

static SERVER: Mutex<Option<Hosted>> = Mutex::new(None);

/// Adds the port unless `address` already has one.
fn with_port(address: &str, port: u16) -> String {
    if address.parse::<SocketAddr>().is_ok() {
        return address.to_string(); // ip:port, [v6]:port
    }
    if let Ok(ip) = address.parse::<IpAddr>() {
        return SocketAddr::new(ip, port).to_string(); // bare IP, v4 or v6
    }
    match address.rsplit_once(':') {
        Some((_, p)) if p.parse::<u16>().is_ok() => address.to_string(), // host:port
        _ => format!("{address}:{port}"),
    }
}

/// Starting and stopping run on one worker thread, in the order SQF asked for them: stopping
/// waits for connections to drain and a restart waits for the port, which must not block
/// Arma's main thread.
enum Job {
    Start { port: u16, address: String },
    Stop,
}

fn worker() -> &'static std::sync::mpsc::Sender<Job> {
    static WORKER: OnceLock<std::sync::mpsc::Sender<Job>> = OnceLock::new();
    WORKER.get_or_init(|| {
        let (tx, rx) = std::sync::mpsc::channel::<Job>();
        std::thread::Builder::new()
            .name("acre-voice-host".into())
            .spawn(move || {
                for job in rx {
                    match job {
                        Job::Start { port, address } => {
                            if let Err(e) = run_start(port, &address) {
                                tracing::warn!(error = %e, "could not start the voice server");
                                emit("authority_failed", vec![e]);
                            }
                        }
                        Job::Stop => stop_running(),
                    }
                }
            })
            .expect("spawning the voice host thread");
        tx
    })
}

fn stop_running() {
    // Retire the authority first, or its connection closing would be reported as the voice
    // server being lost (and SQF would restart it, forever).
    authority::detach();
    let old = SERVER.lock().expect("hosted server").take();
    if let Some(old) = old {
        runtime::get().block_on(old.server.shutdown());
        tracing::info!("voice server stopped");
    }
}

/// How long a restart waits for the previous server (this mission's or the last one's) to let
/// go of the port.
const REBIND_WAIT: Duration = Duration::from_secs(10);

/// Starts the server, retrying while the port is still held by the one just stopped.
fn start_server(config: &Config, identity: &Identity) -> anyhow::Result<Server> {
    let _guard = runtime::get().enter();
    let deadline = Instant::now() + REBIND_WAIT;
    loop {
        match Server::start(config.clone(), identity) {
            Err(e) if addr_in_use(&e) && Instant::now() < deadline => {
                std::thread::sleep(Duration::from_millis(100));
            }
            other => return other,
        }
    }
}

fn addr_in_use(e: &anyhow::Error) -> bool {
    e.chain().any(|c| {
        c.downcast_ref::<std::io::Error>()
            .is_some_and(|io| io.kind() == std::io::ErrorKind::AddrInUse)
    })
}

fn run_start(port: u16, address: &str) -> Result<(), String> {
    if reuse(port, address) {
        return Ok(());
    }
    stop_running();

    let mut secret = [0u8; 32];
    getrandom::fill(&mut secret).map_err(|e| e.to_string())?;
    let secret = Token(secret).to_hex();
    let identity = Identity::generate().map_err(|e| e.to_string())?;
    let fingerprint = identity.fingerprint_hex();

    let mut config = Config::new(secret.clone());
    config.bind = SocketAddr::from(([0, 0, 0, 0], port));
    let server = start_server(&config, &identity)
        .map_err(|e| format!("starting the voice server on UDP {port}: {e:#}"))?;
    let bound = server.local_addr().map_err(|e| e.to_string())?.port();
    let client_address = with_port(address, bound);
    tracing::info!(port = bound, %client_address, "voice server started");
    *SERVER.lock().expect("hosted server") = Some(Hosted {
        server,
        port,
        address: address.to_string(),
        secret: secret.clone(),
        fingerprint: fingerprint.clone(),
        client_address: client_address.clone(),
    });

    authority::connect(
        format!("127.0.0.1:{bound}"),
        secret,
        fingerprint,
        client_address,
    )
    .map(|_| ())
}

/// A start for the server that's already running (a new mission after `#restart` or
/// `#missions`, or SQF recovering a lost authority): keep it, and its players' connections,
/// and report it to the new mission instead of restarting. `false` if it has to (re)start: not
/// running, or a different port or address.
fn reuse(port: u16, address: &str) -> bool {
    let hosted = SERVER.lock().expect("hosted server");
    let Some(h) = hosted.as_ref() else {
        return false;
    };
    if !h.server.is_running() || h.port != port || h.address != address {
        return false;
    }
    let Ok(bound) = h.server.local_addr().map(|a| a.port()) else {
        return false;
    };
    tracing::info!(port = bound, "voice server already running, keeping it");
    if authority::reannounce() {
        return true;
    }
    // Running, but the authority connection is gone: connect it again.
    let reconnect = authority::connect(
        format!("127.0.0.1:{bound}"),
        h.secret.clone(),
        h.fingerprint.clone(),
        h.client_address.clone(),
    );
    if let Err(e) = reconnect {
        tracing::warn!(error = %e, "could not reconnect to the running voice server");
        return false;
    }
    true
}

/// `["server:start", [port, address]]` → `"ok"`, then the `authority_connected` callback (or
/// `authority_failed`). A server already running on the same port and address is kept;
/// otherwise it's restarted.
fn start(port: u16, address: String) -> Result<&'static str, String> {
    let port = match std::env::var("ACRE2_VOICE_PORT") {
        Ok(p) => p
            .trim()
            .parse()
            .map_err(|_| format!("ACRE2_VOICE_PORT is not a port: {p}"))?,
        Err(_) => port,
    };
    let address = std::env::var("ACRE2_VOICE_ADDRESS").unwrap_or(address);
    let address = address.trim().to_string();
    if address.is_empty() {
        return Err(
            "no voice server address set: players need the server's public IP or hostname \
                    (CBA server setting, or ACRE2_VOICE_ADDRESS)"
                .into(),
        );
    }
    worker()
        .send(Job::Start { port, address })
        .map_err(|e| e.to_string())?;
    Ok("ok")
}

/// `["server:stop", []]`: stops the voice server (in the background), e.g. at mission end.
fn stop() {
    authority::detach();
    let _ = worker().send(Job::Stop);
}

pub fn group() -> Group {
    Group::new().command("start", start).command("stop", stop)
}

#[cfg(test)]
mod tests {
    use super::with_port;

    #[test]
    fn adds_port_only_when_missing() {
        assert_eq!(with_port("1.2.3.4", 9987), "1.2.3.4:9987");
        assert_eq!(with_port("1.2.3.4:2000", 9987), "1.2.3.4:2000");
        assert_eq!(
            with_port("voice.example.com", 9987),
            "voice.example.com:9987"
        );
        assert_eq!(
            with_port("voice.example.com:2000", 9987),
            "voice.example.com:2000"
        );
        assert_eq!(with_port("2001:db8::1", 9987), "[2001:db8::1]:9987");
        assert_eq!(with_port("[2001:db8::1]:2000", 9987), "[2001:db8::1]:2000");
    }
}
