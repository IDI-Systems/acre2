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

/// Forgets the current authority connection without reporting it as lost (its own events are
/// ignored from now on). Used before deliberately stopping the hosted voice server.
pub(crate) fn detach() {
    let old = {
        let mut st = state();
        st.generation += 1;
        st.authority.take()
    };
    drop(old);
}

/// Reports the current authority connection again (`authority_connected`), for a new mission
/// on a voice server that kept running. `false` if there is none to report.
pub(crate) fn reannounce() -> bool {
    let (fingerprint, client_address) = {
        let st = state();
        if st.authority.is_none() {
            return false;
        }
        (st.fingerprint.clone(), st.client_address.clone())
    };
    emit("authority_connected", (fingerprint, client_address));
    true
}

/// `["authority:connect", [address, secret, fingerprintHex, clientAddress]]`. An empty
/// fingerprint trusts any certificate; an empty client address uses the server's configured
/// public address, else `address`.
pub(crate) fn connect(
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
        .command("connect", connect)
        .command("token", token)
        .command("world", world)
        .command("remove", remove)
        .command("rules", rules)
        .command("report_position", report_position)
        .command("status", status)
}
