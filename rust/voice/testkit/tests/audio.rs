//! Audio end to end: a speaker bot encodes a voice-like signal through the real transmitter,
//! the server routes it, and a listener bot decodes and mixes it in real time.

use std::time::{Duration, Instant};

use acre2_voice_client::{
    ClientEvent,
    audio::{
        ActivationConfig, DIRECT_TX, Mixer, Outgoing, PassthroughRenderer, Transmitter,
        apply_actions,
    },
};
use acre2_voice_codec::{EncoderConfig, FRAME_SAMPLES, JitterConfig, JitterStats, SAMPLE_RATE};
use acre2_voice_proto::Target;
use acre2_voice_testkit::{Harness, signals::SpeechLike};

#[derive(Debug)]
struct Outcome {
    /// From the speaker's first frame to the first audible frame at the listener.
    latency: Duration,
    audible_frames: usize,
    stats: JitterStats,
}

fn energy(x: &[f32]) -> f32 {
    x.iter().map(|s| s * s).sum::<f32>() / x.len() as f32
}

/// Speaks `frames` frames, then silence until voice activation closes, while the listener
/// renders in real time. `drop_every` drops every n-th voice datagram at the listener.
async fn speak_and_listen(frames: usize, drop_every: Option<u16>) -> anyhow::Result<Outcome> {
    let h = Harness::start().await?;
    let speaker = h.join("speaker").await?;
    let mut listener = h.join("listener").await?;
    h.place(&[("speaker", [0.0; 3]), ("listener", [5.0, 0.0, 0.0])])
        .await?;

    let mut tx = Transmitter::new(EncoderConfig::default(), ActivationConfig::default())?;
    tx.set_direct(Some(Outgoing {
        targets: vec![Target::Spatial { range: 30.0 }],
        metadata: vec![],
    }));
    let mut mixer = Mixer::new(JitterConfig::default());
    let mut voice = SpeechLike::new(SAMPLE_RATE, 0.3);
    let reference = energy(&SpeechLike::new(SAMPLE_RATE, 0.3).next_frame(SAMPLE_RATE as usize));

    let start = Instant::now();
    let now_ms = || start.elapsed().as_millis() as u64;
    let mut tick = tokio::time::interval(Duration::from_millis(20));
    let mut first_audible = None;
    let mut audible_frames = 0;
    let mut stats = None;

    for frame in 0..frames + 50 {
        tick.tick().await;
        let input = if frame < frames {
            voice.next_frame(FRAME_SAMPLES)
        } else {
            vec![0.0; FRAME_SAMPLES]
        };
        apply_actions(&speaker.client, tx.process(&input)?);

        while let Ok(ev) = listener.events.try_recv() {
            match ev {
                ClientEvent::Message(m) => mixer.handle_message(&m, now_ms())?,
                ClientEvent::Voice(v) => {
                    if drop_every.is_some_and(|n| v.seq % n == n - 1) {
                        continue;
                    }
                    mixer.handle_voice(v, now_ms())?;
                }
                ClientEvent::Closed { reason } => anyhow::bail!("closed: {reason}"),
            }
        }
        if let Some(s) = mixer.stats(speaker.client.peer_id(), DIRECT_TX) {
            stats = Some(s);
        }
        let out = mixer.render(&mut PassthroughRenderer, now_ms())?;
        // Audible: at least a quarter of the source's average energy.
        if energy(&out.left) > reference * 0.25 {
            audible_frames += 1;
            first_audible.get_or_insert_with(|| start.elapsed());
        }
    }

    Ok(Outcome {
        latency: first_audible.ok_or_else(|| anyhow::anyhow!("listener never heard anything"))?,
        audible_frames,
        stats: stats.unwrap_or_default(),
    })
}

#[tokio::test(flavor = "multi_thread", worker_threads = 2)]
async fn speech_arrives_quickly_and_completely() -> anyhow::Result<()> {
    let o = speak_and_listen(50, None).await?;
    assert!(o.latency < Duration::from_millis(150), "{o:?}");
    assert!(o.audible_frames >= 48, "{o:?}");
    assert_eq!(o.stats.concealed + o.stats.recovered, 0, "{o:?}");
    Ok(())
}

#[tokio::test(flavor = "multi_thread", worker_threads = 2)]
async fn survives_ten_percent_loss() -> anyhow::Result<()> {
    let o = speak_and_listen(150, Some(10)).await?;
    // Every lost frame is rebuilt from the next packet's FEC data, so speech stays audible.
    assert!(o.stats.recovered >= 14, "{o:?}");
    assert!(o.audible_frames >= 145, "{o:?}");
    Ok(())
}
