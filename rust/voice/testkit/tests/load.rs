//! Load test: many players, many simultaneous speakers, real QUIC on localhost.
//!
//! Ignored by default; run with
//! `cargo test --release -p acre2_voice_testkit --test load -- --ignored --nocapture`.
//! Sizes can be set with `LOAD_PEERS`, `LOAD_SPEAKERS`, `LOAD_SECONDS`.

use std::{
    collections::HashSet,
    sync::{
        Arc,
        atomic::{AtomicU64, Ordering},
    },
    time::{Duration, Instant},
};

use acre2_voice_client::ClientEvent;
use acre2_voice_proto::{ChannelKey, ServerMsg, Target, TxId, Vec3};
use acre2_voice_testkit::Harness;
use bytes::Bytes;

fn env(name: &str, default: usize) -> usize {
    std::env::var(name)
        .ok()
        .and_then(|v| v.parse().ok())
        .unwrap_or(default)
}

/// CPU time used by this process so far (Linux), for a rough cost figure.
fn cpu_time() -> Option<Duration> {
    let stat = std::fs::read_to_string("/proc/self/stat").ok()?;
    let fields: Vec<&str> = stat.rsplit(')').next()?.split_whitespace().collect();
    let ticks: u64 = fields.get(11)?.parse::<u64>().ok()? + fields.get(12)?.parse::<u64>().ok()?;
    Some(Duration::from_millis(ticks * 10)) // USER_HZ is 100 on Linux
}

#[tokio::test(flavor = "multi_thread")]
#[ignore = "load test; run explicitly"]
async fn many_peers_many_speakers() -> anyhow::Result<()> {
    let peers = env("LOAD_PEERS", 120);
    let speakers = env("LOAD_SPEAKERS", 24).min(peers);
    let seconds = env("LOAD_SECONDS", 5);
    let channels = 6;
    let frames = seconds * 50;

    let h = Harness::with_config(|c| c.max_peers = peers + 10).await?;

    // Everyone in a 600 m square; speakers reach 100 m directly and everyone on their radio
    // channel.
    let mut bots = Vec::new();
    let mut placements: Vec<(String, Vec3)> = Vec::new();
    for i in 0..peers {
        let id = format!("p{i}");
        bots.push(h.join(&id).await?);
        let x = ((i * 7919) % 600) as f32;
        let y = ((i * 104_729) % 600) as f32;
        placements.push((id, [x, y, 0.0]));
    }
    let refs: Vec<(&str, Vec3)> = placements.iter().map(|(id, p)| (id.as_str(), *p)).collect();
    h.place(&refs).await?;
    for (i, bot) in bots.iter_mut().enumerate() {
        bot.client
            .set_subscriptions(vec![ChannelKey::new(format!("radio:{}", i % channels))?])?;
        bot.sync().await?;
    }

    // Count what each listener receives, in background tasks.
    let received = Arc::new(AtomicU64::new(0));
    let expected = Arc::new(AtomicU64::new(0));
    let mut tasks = Vec::new();
    let mut speaker_clients = Vec::new();
    for (i, bot) in bots.into_iter().enumerate() {
        let (client, mut events) = (bot.client, bot.events);
        let received = received.clone();
        let expected = expected.clone();
        tasks.push(tokio::spawn(async move {
            let mut streams = HashSet::new();
            while let Some(ev) = events.recv().await {
                match ev {
                    ClientEvent::Voice(_) => {
                        received.fetch_add(1, Ordering::Relaxed);
                    }
                    ClientEvent::Message(ServerMsg::TransmissionStarted {
                        speaker, tx, ..
                    }) => {
                        if streams.insert((speaker, tx)) {
                            expected.fetch_add(frames as u64, Ordering::Relaxed);
                        }
                    }
                    ClientEvent::Closed { .. } => break,
                    ClientEvent::Message(_) => {}
                }
            }
        }));
        if i < speakers {
            client.start_transmission(
                TxId(1),
                vec![
                    Target::Spatial { range: 100.0 },
                    Target::Channel(ChannelKey::new(format!("radio:{}", i % channels))?),
                ],
                vec![],
            )?;
        }
        speaker_clients.push(client);
    }
    tokio::time::sleep(Duration::from_millis(300)).await;

    // Everyone speaking talks for `seconds`, 50 frames a second, ~60 byte packets (24 kbps).
    let cpu_before = cpu_time();
    let start = Instant::now();
    let mut tick = tokio::time::interval(Duration::from_millis(20));
    let payload = Bytes::from(vec![0x55u8; 60]);
    for seq in 0..frames as u16 {
        tick.tick().await;
        for c in speaker_clients.iter().take(speakers) {
            let _ = c.send_voice(TxId(1), seq, 0, payload.clone());
        }
    }
    tokio::time::sleep(Duration::from_millis(500)).await;
    let elapsed = start.elapsed();
    let cpu = cpu_time().zip(cpu_before).map(|(a, b)| a.saturating_sub(b));

    let got = received.load(Ordering::Relaxed);
    let want = expected.load(Ordering::Relaxed);
    let delivery = got as f64 / want.max(1) as f64;
    println!(
        "{peers} peers, {speakers} speakers, {seconds}s: {got}/{want} frames delivered ({:.2}%), \
         {:.0} forwarded datagrams/s, {:.1} kbit/s out of the server, process CPU {:?} ({:.0}% of one core, clients included)",
        delivery * 100.0,
        got as f64 / elapsed.as_secs_f64(),
        got as f64 * (60.0 + 9.0) * 8.0 / elapsed.as_secs_f64() / 1000.0,
        cpu,
        cpu.map_or(0.0, |c| c.as_secs_f64() / elapsed.as_secs_f64() * 100.0),
    );
    assert!(want > 0);
    assert!(delivery > 0.99, "delivered only {:.2}%", delivery * 100.0);

    drop(speaker_clients);
    for t in tasks {
        t.abort();
    }
    Ok(())
}
