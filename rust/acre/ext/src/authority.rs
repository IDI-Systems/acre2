//! Server-side commands: the Arma server as the voice server's authority.
//!
//! Callbacks: `authority_connected` `[fingerprintHex, clientAddress]`, `authority_failed`
//! `[reason]`, `authority_disconnected` `[reason]`, `token` `[uid, tokenHex, clientAddress,
//! fingerprintHex]`, `token_failed` `[uid, reason]`, `peer_connected` / `peer_disconnected`
//! `[uid, peerId]`, `authority_error` `[message]`.

use std::sync::{Arc, LazyLock, Mutex, MutexGuard};

use acre2_voice_client::{Authority, AuthorityEvent, parse_fingerprint};
use acre2_voice_proto::{ChannelRule, Token, WorldUpdate};
use arma_rs::Group;
use tokio::sync::mpsc;

use crate::{callback::emit, runtime};

#[derive(Default)]
struct State {
    authority: Option<Arc<Authority>>,
    generation: u64,
    /// Where players should connect, and the fingerprint they pin.
    client_address: String,
    fingerprint: String,
}

static STATE: LazyLock<Mutex<State>> = LazyLock::new(Mutex::default);

fn state() -> MutexGuard<'static, State> {
    STATE.lock().expect("authority state")
}

fn hex(bytes: &[u8; 32]) -> String {
    Token(*bytes).to_hex()
}

/// The server-side config file, so the secret never passes through SQF (or CBA settings, which
/// are sent to clients).
///
/// ```toml
/// address = "127.0.0.1:9987"          # where this Arma server reaches the voice server
/// secret = "…"                         # the voice server's authority_secret
/// fingerprint = "…"                    # optional: pin the voice server's certificate
/// client_address = "voice.example.com:9987"  # optional: where players connect
/// ```
#[derive(Debug, serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct ServerConfig {
    address: String,
    secret: String,
    #[serde(default)]
    fingerprint: String,
    #[serde(default)]
    client_address: String,
}

/// Where the config lives: `ACRE2_VOICE_CONFIG`, else `acre2_voice.toml` in the working
/// directory (the Arma server's folder).
fn config_path() -> std::path::PathBuf {
    std::env::var_os("ACRE2_VOICE_CONFIG").map_or_else(
        || std::path::PathBuf::from("acre2_voice.toml"),
        std::path::PathBuf::from,
    )
}

/// `["authority:start", []]`: connects using the config file. Errors (synchronously) if it's
/// missing or invalid; otherwise like `authority:connect`.
fn start() -> Result<&'static str, String> {
    let path = config_path();
    let text = std::fs::read_to_string(&path).map_err(|e| format!("{}: {e}", path.display()))?;
    let config: ServerConfig =
        toml::from_str(&text).map_err(|e| format!("{}: {e}", path.display()))?;
    connect(
        config.address,
        config.secret,
        config.fingerprint,
        config.client_address,
    )
}

/// `["authority:connect", [address, secret, fingerprintHex, clientAddress]]`. An empty
/// fingerprint trusts any certificate; an empty client address uses the server's configured
/// public address, else `address`.
fn connect(
    address: String,
    secret: String,
    fingerprint: String,
    client_address: String,
) -> Result<&'static str, String> {
    let pinned = if fingerprint.is_empty() {
        None
    } else {
        Some(parse_fingerprint(&fingerprint).ok_or("invalid fingerprint")?)
    };
    let (generation, old) = {
        let mut st = state();
        st.generation += 1;
        (st.generation, st.authority.take())
    };
    drop(old);
    runtime::get().spawn(async move {
        match Authority::connect(&address, pinned, &secret).await {
            Ok((authority, events)) => {
                let welcome = authority.welcome().clone();
                let client_address = if client_address.is_empty() {
                    welcome
                        .public_address
                        .clone()
                        .unwrap_or_else(|| address.clone())
                } else {
                    client_address
                };
                let fingerprint = hex(&welcome.cert_fingerprint);
                {
                    let mut st = state();
                    if st.generation != generation {
                        return;
                    }
                    st.authority = Some(Arc::new(authority));
                    st.client_address.clone_from(&client_address);
                    st.fingerprint.clone_from(&fingerprint);
                }
                tracing::info!(%address, %client_address, "authority connected to voice server");
                emit("authority_connected", (fingerprint, client_address));
                pump(events, generation).await;
            }
            Err(e) => {
                tracing::warn!(error = %e, %address, "authority could not connect");
                emit("authority_failed", vec![e.to_string()]);
            }
        }
    });
    Ok("ok")
}

async fn pump(mut events: mpsc::Receiver<AuthorityEvent>, generation: u64) {
    while let Some(ev) = events.recv().await {
        if state().generation != generation {
            return;
        }
        match ev {
            AuthorityEvent::PeerConnected {
                external_id,
                peer_id,
            } => {
                emit("peer_connected", (external_id, peer_id.0));
            }
            AuthorityEvent::PeerDisconnected {
                external_id,
                peer_id,
            } => {
                emit("peer_disconnected", (external_id, peer_id.0));
            }
            AuthorityEvent::Error { message } => emit("authority_error", vec![message]),
            AuthorityEvent::Closed { reason } => {
                let mut st = state();
                if st.generation == generation {
                    st.authority = None;
                    drop(st);
                    tracing::warn!(%reason, "authority disconnected from voice server");
                    emit("authority_disconnected", vec![reason]);
                }
                return;
            }
        }
    }
}

fn authority() -> Result<Arc<Authority>, String> {
    state()
        .authority
        .clone()
        .ok_or_else(|| "not connected to the voice server".to_string())
}

/// `["authority:token", [uid]]` → `token` callback.
fn token(uid: String) -> Result<&'static str, String> {
    let authority = authority()?;
    runtime::get().spawn(async move {
        match authority.issue_token(uid.clone()).await {
            Ok(issued) => {
                let (address, fingerprint) = {
                    let st = state();
                    (st.client_address.clone(), st.fingerprint.clone())
                };
                emit("token", (uid, issued.token.to_hex(), address, fingerprint));
            }
            Err(e) => emit("token_failed", (uid, e.to_string())),
        }
    });
    Ok("ok")
}

/// `["authority:world", [[[uid, posASL, active], …]]]`
fn world(players: Vec<(String, [f32; 3], bool)>) -> Result<(), String> {
    let updates = players
        .into_iter()
        .map(|(external_id, position, active)| WorldUpdate {
            external_id,
            position,
            active,
        })
        .collect();
    authority()?
        .update_world(updates)
        .map_err(|e| e.to_string())
}

/// `["authority:remove", [uid]]`
fn remove(uid: String) -> Result<(), String> {
    authority()?.remove_player(uid).map_err(|e| e.to_string())
}

/// `["authority:rules", [uid, [[prefix, allowTx, allowRx], …]]]` (`uid` `""` for everyone).
fn rules(uid: String, rules: Vec<(String, bool, bool)>) -> Result<(), String> {
    let rules = rules
        .into_iter()
        .map(|(prefix, allow_tx, allow_rx)| ChannelRule {
            prefix,
            allow_tx,
            allow_rx,
        })
        .collect();
    let uid = (!uid.is_empty()).then_some(uid);
    authority()?
        .set_channel_rules(uid, rules)
        .map_err(|e| e.to_string())
}

/// `["authority:report_position", [uid, allowed]]`: lets a curator/spectator report camera
/// positions.
fn report_position(uid: String, allowed: bool) -> Result<(), String> {
    authority()?
        .set_report_position(uid, allowed)
        .map_err(|e| e.to_string())
}

/// `["authority:status", []]` → `[connected, clientAddress, fingerprintHex]`
fn status() -> (bool, String, String) {
    let st = state();
    (
        st.authority.is_some(),
        st.client_address.clone(),
        st.fingerprint.clone(),
    )
}

pub fn group() -> Group {
    Group::new()
        .command("start", start)
        .command("connect", connect)
        .command("token", token)
        .command("world", world)
        .command("remove", remove)
        .command("rules", rules)
        .command("report_position", report_position)
        .command("status", status)
}
