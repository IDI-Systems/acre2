//! The microphone filter as voice activation sees it: typing alone doesn't open the mic,
//! speech does (also over background noise), and the noise is taken out of what's sent.

use acre2_voice_client::audio::{
    ActivationConfig, Denoiser, NoiseConfig, Outgoing, Transmitter, TxAction, level_db,
};
use acre2_voice_codec::{EncoderConfig, FRAME_SAMPLES};
use acre2_voice_proto::Target;
use acre2_voice_testkit::signals::{FanNoise, KeyboardClicks, SpeechLike};

const RATE: u32 = 48_000;

fn transmitter(noise: NoiseConfig) -> Transmitter {
    let mut t = Transmitter::new(EncoderConfig::default(), ActivationConfig::default()).unwrap();
    t.set_direct(Some(Outgoing {
        targets: vec![Target::Spatial { range: 30.0 }],
        metadata: vec![],
    }));
    t.set_noise(noise);
    t
}

/// Frames (of `frames`) on which anything was sent.
fn sending(t: &mut Transmitter, frames: usize, mut next: impl FnMut() -> Vec<f32>) -> Vec<usize> {
    (0..frames)
        .filter(|_| {
            t.process(&next())
                .unwrap()
                .iter()
                .any(|a| matches!(a, TxAction::Voice { .. }))
        })
        .collect()
}

fn mix(a: &[f32], b: &[f32]) -> Vec<f32> {
    a.iter().zip(b).map(|(x, y)| x + y).collect()
}

#[test]
fn typing_alone_does_not_open_voice_activation() {
    // Ten seconds of fairly loud typing: plain level-based activation sends nearly all of it…
    let mut clicks = KeyboardClicks::new(RATE, 0.5);
    let mut plain = transmitter(NoiseConfig::default());
    let sent = sending(&mut plain, 500, || clicks.next_frame(FRAME_SAMPLES)).len();
    assert!(
        sent > 400,
        "the clicks are loud enough: {sent} of 500 frames sent"
    );

    // …speech detection next to none (the odd click that sounds like a syllable, plus its
    // hangover).
    let mut clicks = KeyboardClicks::new(RATE, 0.5);
    let mut filtered = transmitter(NoiseConfig::ON);
    let sent = sending(&mut filtered, 500, || clicks.next_frame(FRAME_SAMPLES)).len();
    assert!(sent <= 25, "typing sent {sent} of 500 frames");
}

#[test]
fn speech_opens_promptly_over_background_noise() {
    let mut t = transmitter(NoiseConfig::ON);
    let mut fan = FanNoise::new(RATE, 0.01);
    // Two seconds of just the fan: never opens.
    let sent = sending(&mut t, 100, || fan.next_frame(FRAME_SAMPLES));
    assert!(sent.is_empty(), "background noise opened the mic: {sent:?}");
    // Then talking: opens within 60 ms.
    let mut voice = SpeechLike::new(RATE, 0.1);
    let sent = sending(&mut t, 50, || {
        mix(
            &voice.next_frame(FRAME_SAMPLES),
            &fan.next_frame(FRAME_SAMPLES),
        )
    });
    assert!(
        sent.first().is_some_and(|i| *i <= 2),
        "speech opened at {sent:?}"
    );
}

#[test]
fn background_noise_is_taken_out_between_words() {
    // Half a second of talking, half a second of pause, over a fan, for six seconds.
    let mut d = Denoiser::new();
    let mut voice = SpeechLike::new(RATE, 0.1);
    let mut fan = FanNoise::new(RATE, 0.02);
    let (mut pauses_in, mut pauses_out, mut talk_in, mut talk_out) =
        (vec![], vec![], vec![], vec![]);
    for i in 0..300 {
        let talking = (i / 25) % 2 == 0;
        let n = fan.next_frame(FRAME_SAMPLES);
        let v = voice.next_frame(FRAME_SAMPLES);
        let mut f = if talking { mix(&v, &n) } else { n };
        let before = f.clone();
        d.process(&mut f, true);
        // After two seconds of learning; skipping 60 ms either side of each switch.
        if i >= 100 && (3..22).contains(&(i % 25)) {
            if talking {
                talk_in.extend(before);
                talk_out.extend(f);
            } else {
                pauses_in.extend(before);
                pauses_out.extend(f);
            }
        }
    }
    let (fan_level, left) = (level_db(&pauses_in), level_db(&pauses_out));
    assert!(
        left < fan_level - 15.0,
        "fan at {fan_level:.1} dB, {left:.1} dB of it left between words"
    );
    let (speech_in, speech_out) = (level_db(&talk_in), level_db(&talk_out));
    assert!(
        (speech_in - speech_out).abs() < 3.0,
        "speech {speech_in:.1} dB → {speech_out:.1} dB"
    );
}
