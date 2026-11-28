//! The extension end to end, as Arma would drive it: hosting the voice server and issuing a token
//! (the Arma server's side), and as a player connecting with it and transmitting.
//!
//! One test, because the extension's state is process-global. Uses ALSA's null devices so no
//! real microphone or speakers are touched.

use std::time::Duration;

use arma_rs::{Value, testing::Result as CbResult};

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
    let ext = super::init().testing();
    assert_eq!(call(&ext, "init", &[]), env!("CARGO_PKG_VERSION"));

    // Server side: a missing address is refused up front.
    let (out, code) = ext.call("server:start", Some(vec!["0".into(), s("")]));
    assert_ne!(code, 0);
    assert!(out.contains("address"), "{out}");

    // Host the voice server (any free port), place the player, get them a token.
    call(&ext, "server:start", &["0".into(), s("127.0.0.1")]);
    let welcome = wait_for(&ext, "authority_connected", "authority_failed");
    assert!(welcome[1].starts_with("127.0.0.1:"), "{welcome:?}");

    // Starting again restarts quietly: no "disconnected" for the server we stopped ourselves.
    // From here on a fixed port, as on a real server, so restarts must wait for the port.
    let port = std::net::UdpSocket::bind("127.0.0.1:0")
        .unwrap()
        .local_addr()
        .unwrap()
        .port()
        .to_string();
    call(&ext, "server:start", &[port.clone(), s("127.0.0.1")]);
    let lost = std::cell::Cell::new(false);
    let restarted = ext.callback_handler(
        |_, func, data| match func {
            "authority_disconnected" => {
                lost.set(true);
                CbResult::Continue
            }
            "authority_connected" => CbResult::Ok(strings(data)),
            _ => CbResult::<Vec<String>, ()>::Continue,
        },
        WAIT,
    );
    let CbResult::Ok(welcome) = restarted else {
        panic!("restart never connected")
    };
    assert!(
        !lost.get(),
        "a deliberate restart was reported as the server being lost"
    );
    let addr = welcome[1].clone();
    assert!(
        addr.starts_with("127.0.0.1:") && !addr.ends_with(":0"),
        "{addr}"
    );
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
    // The null microphone's silence isn't speech: switch speech detection (and suppression)
    // off for this.
    call(&ext, "vox:noise", &["false".into(), "false".into()]);
    call(
        &ext,
        "vox:settings",
        &[s("vad"), "-200".into(), "-200".into()],
    );
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

    // Stats while connected: [state, peer, address, rtt, …].
    let stats = call(&ext, "voice:stats", &[]);
    assert!(
        stats.starts_with(&format!("[\"connected\",{peer},")),
        "{stats}"
    );

    // Receiving a radio transmission: another player (a bare client, far out of direct range)
    // talks on a radio channel we listen to.
    let channel = "radio:singleChannel:43.10000";
    call(&ext, "rx:channels", &[format!("[{}]", s(channel))]);
    call(
        &ext,
        "authority:world",
        &[r#"[["7656", [0, 0, 0], true], ["bot", [5000, 0, 0], true]]"#.into()],
    );
    call(&ext, "authority:token", &[s("bot")]);
    let bot_token = wait_for(&ext, "token", "token_failed");
    let (bot_peer_tx, bot_peer_rx) = std::sync::mpsc::channel();
    let bot = std::thread::spawn(move || radio_bot(&bot_token, channel, &bot_peer_tx));
    let bot_peer = bot_peer_rx.recv_timeout(WAIT).expect("bot connected");
    let start = wait_for(&ext, "remote_start", "disconnected");
    assert_eq!(start[0], bot_peer.to_string());
    assert_eq!(
        (start[3].as_str(), start[4].as_str()),
        ("1", "ACRE_PRC152_ID_2"),
        "radio speech: {start:?}"
    );
    call(
        &ext,
        "speaker:radio",
        &[
            bot_peer.to_string(),
            "false".into(),
            "[[1, 1, false, [0, 0, 0]]]".into(),
        ],
    );
    let deadline = std::time::Instant::now() + WAIT;
    loop {
        let stats = call(&ext, "voice:stats", &[]);
        let fields: Vec<&str> = stats.trim_matches(['[', ']']).split(',').collect();
        // Playing now, or at least decoded: the null output device drains as fast as it's fed,
        // so the jitter buffer can run dry between polls and conceal most frames.
        let rx_loss: f64 = fields[5].parse().unwrap();
        if fields[8] != "0" || (rx_loss > 0.0 && rx_loss < 100.0) {
            break;
        }
        assert!(
            std::time::Instant::now() < deadline,
            "radio speech never played: {stats}"
        );
        std::thread::sleep(Duration::from_millis(50));
    }
    bot.join().expect("bot thread");
    wait_for(&ext, "remote_stop", "disconnected");

    // Hearing ourselves on another radio: with loopback on, a radio transmission is also played
    // back to us as our own peer's stream (rendered with speaker:radio for our own id), without
    // telling SQF that we're a remote speaker.
    call(&ext, "tx:loopback", &["true".into()]);
    call(
        &ext,
        "tx:start",
        &[
            s("radio2"),
            "1".into(),
            s("ACRE_PRC152_ID_3"),
            "30".into(),
            r#"["radio:43.200"]"#.into(),
            s("2:5"),
            "0".into(),
            "1".into(),
        ],
    );
    let result: CbResult<(), Vec<String>> = ext.callback_handler(
        |_, func, data| {
            let data = strings(data);
            match func {
                "remote_start" if data[0] == peer.to_string() => CbResult::Err(data),
                "local_start" if data[3] == "ACRE_PRC152_ID_3" => CbResult::Ok(()),
                _ => CbResult::Continue,
            }
        },
        WAIT,
    );
    assert!(result.is_ok(), "radio2 didn't start cleanly: {result:?}");
    call(
        &ext,
        "speaker:radio",
        &[
            peer.to_string(),
            "false".into(),
            "[[1, 1, false, [2, 0, 0]]]".into(),
        ],
    );
    let deadline = std::time::Instant::now() + WAIT;
    while crate::client::own_streams() != (1, true) {
        assert!(
            std::time::Instant::now() < deadline,
            "own radio not looped back: {:?}",
            crate::client::own_streams()
        );
        std::thread::sleep(Duration::from_millis(20));
    }
    call(&ext, "tx:stop", &[s("radio2")]);
    let deadline = std::time::Instant::now() + WAIT;
    while crate::client::own_streams() != (0, false) {
        assert!(
            std::time::Instant::now() < deadline,
            "loopback didn't end: {:?}",
            crate::client::own_streams()
        );
        std::thread::sleep(Duration::from_millis(20));
    }
    // No remote_start/remote_stop for ourselves came meanwhile.
    let leaked: CbResult<(), Vec<String>> = ext.callback_handler(
        |_, func, data| {
            let data = strings(data);
            if func.starts_with("remote_") && data[0] == peer.to_string() {
                CbResult::Err(data)
            } else {
                CbResult::Continue
            }
        },
        Duration::from_millis(300),
    );
    assert!(!matches!(leaked, CbResult::Err(_)), "{leaked:?}");

    // Bad arguments are refused rather than panicking.
    let (_, code) = ext.call(
        "vox:settings",
        Some(vec![s("loud"), "0".into(), "0".into()]),
    );
    assert_ne!(code, 0);

    // The next mission (#restart, #missions) asks for the same server again: it keeps running,
    // with the same certificate and its players still connected.
    call(&ext, "server:start", &[port.clone(), s("127.0.0.1")]);
    let again = wait_for(&ext, "authority_connected", "authority_failed");
    assert_eq!(
        again, welcome,
        "the running server is reported, not restarted"
    );
    std::thread::sleep(Duration::from_millis(300));
    assert!(call(&ext, "voice:status", &[]).contains("\"connected\""));

    // A changed setting restarts it on the same port, with players still connected to the old
    // one: it must not fail with "address in use".
    call(&ext, "server:start", &[port.clone(), s("localhost")]);
    let seen = wait_all(&ext, &["authority_connected", "disconnected"]);
    assert_eq!(seen["authority_connected"][1], format!("localhost:{port}"));
    assert_ne!(
        seen["authority_connected"][0], welcome[0],
        "new certificate"
    );
    assert!(call(&ext, "voice:status", &[]).contains("disconnected"));
    call(&ext, "voice:disconnect", &[]);
    call(&ext, "server:stop", &[]);
}

/// Connects as another player with `token` (`[id, token, address, fingerprint]`) and talks for a
/// second on `channel` with radio metadata.
fn radio_bot(token: &[String], channel: &str, peer: &std::sync::mpsc::Sender<u32>) {
    use acre2_voice_proto::{ChannelKey, Target, Token, TxId};
    let rt = tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()
        .unwrap();
    rt.block_on(async {
        let (client, _events) = acre2_voice_client::Client::connect(
            &token[2],
            acre2_voice_client::parse_fingerprint(&token[3]).unwrap(),
            Token::from_hex(&token[1]).unwrap(),
        )
        .await
        .expect("bot connects");
        peer.send(client.peer_id().0).unwrap();
        let meta = crate::meta::Meta {
            speaking_type: crate::meta::speaking_type::RADIO,
            radio_id: "ACRE_PRC152_ID_2".into(),
            net_id: "2:9".into(),
            language_id: 0,
            curve_scale: 1.0,
        };
        let tx = TxId(1);
        client
            .start_transmission(
                tx,
                vec![
                    Target::Spatial { range: 50.0 },
                    Target::Channel(ChannelKey::new(channel).unwrap()),
                ],
                meta.encode(),
            )
            .unwrap();
        let mut encoder =
            acre2_voice_codec::VoiceEncoder::new(acre2_voice_codec::EncoderConfig::default())
                .unwrap();
        let n = encoder.frame_samples();
        let mut t = 0usize;
        for seq in 0..100u16 {
            let frame: Vec<f32> = (0..n)
                .map(|i| {
                    let x = (t + i) as f32 / 48_000.0;
                    0.3 * (x * 2.0 * std::f32::consts::PI * 220.0).sin()
                })
                .collect();
            t += n;
            let payload = encoder.encode(&frame).unwrap();
            client.send_voice(tx, seq, 0, payload).unwrap();
            tokio::time::sleep(Duration::from_millis(20)).await;
        }
        client.stop_transmission(tx).unwrap();
        tokio::time::sleep(Duration::from_millis(200)).await;
    });
}
