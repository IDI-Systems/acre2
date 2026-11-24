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
    sync::Mutex,
};

use acre2_voice_proto::Token;
use acre2_voice_server::{Config, Identity, Server};
use arma_rs::Group;

use crate::{authority, runtime};

static SERVER: Mutex<Option<Server>> = Mutex::new(None);

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

fn stop_running() {
    // Retire the authority first, or its connection closing would be reported as the voice
    // server being lost (and SQF would restart it, forever).
    authority::detach();
    let old = SERVER.lock().expect("hosted server").take();
    if let Some(old) = old {
        runtime::get().block_on(old.shutdown());
    }
}

/// `["server:start", [port, address]]` → `"ok"`, then the `authority_connected` callback.
/// Restarts the voice server if it was already running.
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

    stop_running();

    let mut secret = [0u8; 32];
    getrandom::fill(&mut secret).map_err(|e| e.to_string())?;
    let secret = Token(secret).to_hex();
    let identity = Identity::generate().map_err(|e| e.to_string())?;
    let fingerprint = identity.fingerprint_hex();

    let mut config = Config::new(secret.clone());
    config.bind = SocketAddr::from(([0, 0, 0, 0], port));
    let server = {
        let _guard = runtime::get().enter();
        Server::start(config, &identity)
            .map_err(|e| format!("starting the voice server on UDP {port}: {e:#}"))?
    };
    let bound = server.local_addr().map_err(|e| e.to_string())?.port();
    let client_address = with_port(&address, bound);
    tracing::info!(port = bound, %client_address, "voice server started");
    *SERVER.lock().expect("hosted server") = Some(server);

    authority::connect(
        format!("127.0.0.1:{bound}"),
        secret,
        fingerprint,
        client_address,
    )
}

/// `["server:stop", []]`
fn stop() {
    stop_running();
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
