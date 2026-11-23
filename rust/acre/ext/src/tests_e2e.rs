//! The extension end to end, as Arma would drive it: a real voice server, the extension as the
//! authority issuing a token, and as a player connecting with it and transmitting.
//!
//! One test, because the extension's state is process-global. Uses ALSA's null devices so no
//! real microphone or speakers are touched.

use std::time::Duration;

use acre2_voice_server::{Config, Identity, Server};
use arma_rs::{Value, testing::Result as CbResult};

const SECRET: &str = "ext-test-secret";
const WAIT: Duration = Duration::from_secs(10);

fn s(v: &str) -> String {
    format!("\"{v}\"")
}

fn strings(data: Option<Value>) -> Vec<String> {
    match data {
        Some(Value::Array(items)) => items
            .into_iter()
            .map(|v| match v {
                Value::String(s) => s,
                other => other.to_string(),
            })
            .collect(),
        Some(Value::String(s)) => vec![s],
        Some(other) => vec![other.to_string()],
        None => vec![],
    }
}

/// Waits for the callback `want`, failing on `fail`.
fn wait_for(ext: &arma_rs::testing::Extension, want: &str, fail: &str) -> Vec<String> {
    let result = ext.callback_handler(
        |name, func, data| {
            assert_eq!(name, "acre_voice");
            if func == want {
                CbResult::Ok(strings(data))
            } else if func == fail {
                CbResult::Err(strings(data))
            } else {
                CbResult::Continue
            }
        },
        WAIT,
    );
    match result {
        CbResult::Ok(v) => v,
        CbResult::Err(e) => panic!("{fail}: {e:?}"),
        _ => panic!("timed out waiting for {want}"),
    }
}

/// Waits for all of `want`, in any order.
fn wait_all(
    ext: &arma_rs::testing::Extension,
    want: &[&str],
) -> std::collections::HashMap<String, Vec<String>> {
    let seen = std::cell::RefCell::new(std::collections::HashMap::new());
    let result: CbResult<(), ()> = ext.callback_handler(
        |_, func, data| {
            if want.contains(&func) {
                seen.borrow_mut().insert(func.to_string(), strings(data));
            }
            if want.iter().all(|w| seen.borrow().contains_key(*w)) {
                CbResult::Ok(())
            } else {
                CbResult::Continue
            }
        },
        WAIT,
    );
    assert!(
        result.is_ok(),
        "timed out waiting for {want:?}, saw {:?}",
        seen.borrow()
    );
    seen.into_inner()
}

fn call(ext: &arma_rs::testing::Extension, function: &str, args: &[String]) -> String {
    let (out, code) = ext.call(function, Some(args.to_vec()));
    assert_eq!(code, 0, "{function} failed: {out}");
    out
}

#[test]
fn authority_token_connect_and_transmit() {
    // The voice server, on the extension's own runtime.
    let rt = crate::runtime::get();
    let mut config = Config::new(SECRET);
    config.bind = "127.0.0.1:0".parse().unwrap();
    let server =
        rt.block_on(async { Server::start(config, &Identity::generate().unwrap()).unwrap() });
    let addr = server.local_addr().unwrap().to_string();

    let ext = super::init().testing();
    assert_eq!(call(&ext, "init", &[]), env!("CARGO_PKG_VERSION"));

    // Server side: connect as the authority, place the player, get them a token.
    call(
        &ext,
        "authority:connect",
        &[s(&addr), s(SECRET), s(""), s("")],
    );
    let welcome = wait_for(&ext, "authority_connected", "authority_failed");
    assert_eq!(welcome[1], addr);
    call(
        &ext,
        "authority:world",
        &[r#"[["7656", [0, 0, 0], true]]"#.into()],
    );
    call(&ext, "authority:token", &[s("7656")]);
    let token = wait_for(&ext, "token", "token_failed");
    assert_eq!(token[0], "7656");
    assert_eq!(
        token[3], welcome[0],
        "clients pin the fingerprint the authority saw"
    );

    // Player side.
    call(&ext, "audio:select", &[s("alsa:null"), s("alsa:null")]);
    call(
        &ext,
        "voice:connect",
        &[s(&token[2]), s(&token[1]), s(&token[3])],
    );
    let seen = wait_all(&ext, &["connected", "peer_connected"]);
    let peer: u32 = seen["connected"][0].parse().unwrap();
    assert_eq!(
        seen["peer_connected"],
        vec!["7656".to_string(), peer.to_string()]
    );
    assert!(call(&ext, "voice:status", &[]).contains("connected"));

    // Voice activation with a threshold below silence: the null microphone's zeros count as
    // speech, so direct speech starts.
    call(
        &ext,
        "tx:direct",
        &["50".into(), "[]".into(), s("2:5"), "0".into(), "1".into()],
    );
    call(&ext, "vox:settings", &[s("vad"), "-200".into()]);
    let started = wait_for(&ext, "local_start", "disconnected");
    assert_eq!(started[0], peer.to_string());
    assert_eq!(started[2], "0", "direct speech");

    // A radio PTT replaces direct speech (exclusive mode).
    call(
        &ext,
        "tx:start",
        &[
            s("radio1"),
            "1".into(),
            s("ACRE_PRC152_ID_1"),
            "30".into(),
            r#"["radio:43.100"]"#.into(),
            s("2:5"),
            "0".into(),
            "1".into(),
        ],
    );
    let stopped = wait_for(&ext, "local_stop", "disconnected");
    assert_eq!(stopped[2], "0");
    let started = wait_for(&ext, "local_start", "disconnected");
    assert_eq!(
        (started[2].as_str(), started[3].as_str()),
        ("1", "ACRE_PRC152_ID_1")
    );

    // Bad arguments are refused rather than panicking.
    let (_, code) = ext.call("vox:settings", Some(vec![s("loud"), "0".into()]));
    assert_ne!(code, 0);

    call(&ext, "voice:disconnect", &[]);
    assert!(call(&ext, "voice:status", &[]).contains("disconnected"));
    rt.block_on(server.shutdown());
}
