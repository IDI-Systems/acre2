//! Receives remote transmissions and mixes them into a stereo frame.
//!
//! Device-free: feed it server messages and voice datagrams, then call [`Mixer::render`] once per
//! frame period. How each stream sounds (position, radio effects, volume) is up to the
//! [`Renderer`]; the default plays every stream centred at full volume.

use std::collections::HashMap;

use acre2_voice_codec::{CodecError, FrameKind, JitterConfig, JitterStats, VoiceStream};
use acre2_voice_proto::{MatchedTarget, PeerId, ServerMsg, TxId, datagram::ServerVoice};

/// A remote transmission, as announced by the server.
#[derive(Debug, Clone, PartialEq)]
pub struct StreamInfo {
    pub speaker: PeerId,
    pub speaker_external_id: String,
    pub tx: TxId,
    pub matched: Vec<MatchedTarget>,
    pub metadata: Vec<u8>,
}

/// One frame of stereo audio.
#[derive(Debug, Clone, PartialEq)]
pub struct StereoFrame {
    pub left: Vec<f32>,
    pub right: Vec<f32>,
}

impl StereoFrame {
    #[must_use]
    pub fn new(samples: usize) -> Self {
        Self {
            left: vec![0.0; samples],
            right: vec![0.0; samples],
        }
    }

    pub fn clear(&mut self) {
        self.left.fill(0.0);
        self.right.fill(0.0);
    }

    /// Adds a mono signal with per-channel gains.
    pub fn add_mono(&mut self, mono: &[f32], gain_left: f32, gain_right: f32) {
        for ((l, r), s) in self.left.iter_mut().zip(&mut self.right).zip(mono) {
            *l += s * gain_left;
            *r += s * gain_right;
        }
    }
}

/// Decides how each remote stream sounds.
pub trait Renderer: Send {
    /// Adds one stream's decoded frame into `out`. `mono` may be modified in place.
    fn render(
        &mut self,
        info: &StreamInfo,
        kind: FrameKind,
        mono: &mut [f32],
        out: &mut StereoFrame,
    );

    /// Called after all streams, e.g. to add local sounds. Default: nothing.
    fn finish(&mut self, _out: &mut StereoFrame) {}

    /// A stream finished playing and was removed.
    fn stream_removed(&mut self, _info: &StreamInfo) {}
}

/// Plays every stream centred at full volume.
#[derive(Debug, Default, Clone, Copy)]
pub struct PassthroughRenderer;

impl Renderer for PassthroughRenderer {
    fn render(&mut self, _: &StreamInfo, _: FrameKind, mono: &mut [f32], out: &mut StereoFrame) {
        out.add_mono(mono, 1.0, 1.0);
    }
}

/// Voice for a transmission the server hasn't announced yet (a datagram overtook the control
/// message) is kept this long before being discarded.
const ORPHAN_TIMEOUT_MS: u64 = 2000;

#[derive(Debug)]
struct Stream {
    info: Option<StreamInfo>,
    voice: VoiceStream,
    ended: bool,
    created_ms: u64,
}

#[derive(Debug)]
pub struct Mixer {
    config: JitterConfig,
    streams: HashMap<(PeerId, TxId), Stream>,
    mono: Vec<f32>,
    out: StereoFrame,
    muted: std::collections::HashSet<PeerId>,
    totals: ReceiveTotals,
}

/// Frames played from all streams so far, by how they were produced. Recovered and concealed
/// frames are incoming packet loss.
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
pub struct ReceiveTotals {
    pub audio: u64,
    pub recovered: u64,
    pub concealed: u64,
}

impl ReceiveTotals {
    /// Share of frames that were lost (recovered or concealed), 0–1.
    #[must_use]
    pub fn loss(&self) -> f64 {
        let lost = self.recovered + self.concealed;
        let total = self.audio + lost;
        if total == 0 {
            0.0
        } else {
            lost as f64 / total as f64
        }
    }
}

impl Mixer {
    #[must_use]
    pub fn new(config: JitterConfig) -> Self {
        let samples = config.frame_samples();
        Self {
            config,
            streams: HashMap::new(),
            mono: vec![0.0; samples],
            out: StereoFrame::new(samples),
            muted: std::collections::HashSet::new(),
            totals: ReceiveTotals::default(),
        }
    }

    #[must_use]
    pub fn frame_samples(&self) -> usize {
        self.config.frame_samples()
    }

    fn stream(&mut self, key: (PeerId, TxId), now_ms: u64) -> Result<&mut Stream, CodecError> {
        if !self.streams.contains_key(&key) {
            self.streams.insert(
                key,
                Stream {
                    info: None,
                    voice: VoiceStream::new(self.config)?,
                    ended: false,
                    created_ms: now_ms,
                },
            );
        }
        Ok(self.streams.get_mut(&key).expect("inserted above"))
    }

    /// Applies a control message. Only transmission start/end matter; others are ignored.
    pub fn handle_message(&mut self, msg: &ServerMsg, now_ms: u64) -> Result<(), CodecError> {
        match msg {
            ServerMsg::TransmissionStarted {
                speaker,
                speaker_external_id,
                tx,
                matched,
                metadata,
            } => {
                let s = self.stream((*speaker, *tx), now_ms)?;
                s.info = Some(StreamInfo {
                    speaker: *speaker,
                    speaker_external_id: speaker_external_id.clone(),
                    tx: *tx,
                    matched: matched.clone(),
                    metadata: metadata.clone(),
                });
                s.ended = false;
            }
            ServerMsg::TransmissionEnded { speaker, tx } => {
                if let Some(s) = self.streams.get_mut(&(*speaker, *tx)) {
                    s.ended = true;
                }
            }
            _ => {}
        }
        Ok(())
    }

    /// Adds a received voice frame.
    pub fn handle_voice(&mut self, voice: ServerVoice, now_ms: u64) -> Result<(), CodecError> {
        let eos = voice.end_of_spurt();
        let s = self.stream((voice.speaker, voice.tx), now_ms)?;
        s.voice.push(voice.seq, eos, voice.payload, now_ms);
        Ok(())
    }

    /// Locally mutes a speaker: their streams are decoded but not rendered.
    pub fn set_muted(&mut self, speaker: PeerId, muted: bool) {
        if muted {
            self.muted.insert(speaker);
        } else {
            self.muted.remove(&speaker);
        }
    }

    /// Streams currently announced.
    pub fn streams(&self) -> impl Iterator<Item = (&StreamInfo, bool)> {
        self.streams
            .values()
            .filter_map(|s| s.info.as_ref().map(|i| (i, s.voice.is_playing())))
    }

    #[must_use]
    pub fn totals(&self) -> ReceiveTotals {
        self.totals
    }

    /// Streams currently playing.
    #[must_use]
    pub fn playing(&self) -> usize {
        self.streams
            .values()
            .filter(|s| s.info.is_some() && s.voice.is_playing())
            .count()
    }

    #[must_use]
    pub fn stats(&self, speaker: PeerId, tx: TxId) -> Option<JitterStats> {
        self.streams.get(&(speaker, tx)).map(|s| s.voice.stats())
    }

    /// Renders one frame.
    pub fn render(
        &mut self,
        renderer: &mut dyn Renderer,
        now_ms: u64,
    ) -> Result<&StereoFrame, CodecError> {
        self.out.clear();
        let mut removed = Vec::new();
        for (key, s) in &mut self.streams {
            let kind = s.voice.next_frame(&mut self.mono)?;
            match kind {
                FrameKind::Audio => self.totals.audio += 1,
                FrameKind::Recovered => self.totals.recovered += 1,
                FrameKind::Concealed => self.totals.concealed += 1,
                FrameKind::Silence => {}
            }
            match &s.info {
                Some(info) => {
                    if kind != FrameKind::Silence && !self.muted.contains(&info.speaker) {
                        renderer.render(info, kind, &mut self.mono, &mut self.out);
                    }
                    if s.ended && !s.voice.is_playing() && kind == FrameKind::Silence {
                        removed.push(*key);
                    }
                }
                None => {
                    if now_ms.saturating_sub(s.created_ms) > ORPHAN_TIMEOUT_MS {
                        removed.push(*key);
                    }
                }
            }
        }
        for key in removed {
            if let Some(Stream {
                info: Some(info), ..
            }) = self.streams.remove(&key)
            {
                renderer.stream_removed(&info);
            }
        }
        renderer.finish(&mut self.out);
        soft_clip(&mut self.out.left);
        soft_clip(&mut self.out.right);
        Ok(&self.out)
    }
}

/// Leaves normal levels untouched and bends peaks smoothly below 1.0 instead of hard clipping.
fn soft_clip(samples: &mut [f32]) {
    const KNEE: f32 = 0.8;
    for s in samples {
        let a = s.abs();
        if a > KNEE {
            let over = (a - KNEE) / (1.0 - KNEE);
            *s = s.signum() * (KNEE + (1.0 - KNEE) * over.tanh());
        }
    }
}

#[cfg(test)]
mod tests {
    use acre2_voice_codec::{EncoderConfig, FRAME_SAMPLES, VoiceEncoder};
    use acre2_voice_proto::datagram::flags;
    use bytes::Bytes;

    use super::*;

    fn tone(i: usize) -> Vec<f32> {
        (0..FRAME_SAMPLES)
            .map(|n| 0.4 * ((i * FRAME_SAMPLES + n) as f32 * 0.05).sin())
            .collect()
    }

    fn started(speaker: u32, tx: u16) -> ServerMsg {
        ServerMsg::TransmissionStarted {
            speaker: PeerId(speaker),
            speaker_external_id: format!("p{speaker}"),
            tx: TxId(tx),
            matched: vec![],
            metadata: vec![],
        }
    }

    fn voice(speaker: u32, tx: u16, seq: u16, eos: bool, payload: Bytes) -> ServerVoice {
        ServerVoice {
            speaker: PeerId(speaker),
            tx: TxId(tx),
            seq,
            flags: if eos { flags::END_OF_SPURT } else { 0 },
            payload,
        }
    }

    fn energy(f: &StereoFrame) -> f32 {
        f.left.iter().map(|s| s * s).sum()
    }

    #[test]
    fn mixes_announced_streams_and_cleans_up() {
        let mut enc = VoiceEncoder::new(EncoderConfig::default()).unwrap();
        let mut mixer = Mixer::new(JitterConfig::default());
        let mut r = PassthroughRenderer;
        mixer.handle_message(&started(1, 0), 0).unwrap();
        let mut loud_frames = 0;
        for i in 0..20u16 {
            let p = enc.encode(&tone(i as usize)).unwrap();
            mixer
                .handle_voice(voice(1, 0, i, i == 19, p), u64::from(i) * 20)
                .unwrap();
            if energy(mixer.render(&mut r, u64::from(i) * 20).unwrap()) > 0.1 {
                loud_frames += 1;
            }
        }
        assert!(loud_frames > 10, "{loud_frames}");
        mixer
            .handle_message(
                &ServerMsg::TransmissionEnded {
                    speaker: PeerId(1),
                    tx: TxId(0),
                },
                400,
            )
            .unwrap();
        for i in 0..5 {
            mixer.render(&mut r, 400 + i * 20).unwrap();
        }
        assert_eq!(mixer.streams().count(), 0);
    }

    #[test]
    fn early_voice_waits_for_announcement() {
        let mut enc = VoiceEncoder::new(EncoderConfig::default()).unwrap();
        let mut mixer = Mixer::new(JitterConfig::default());
        let mut r = PassthroughRenderer;
        let p = enc.encode(&tone(0)).unwrap();
        mixer.handle_voice(voice(2, 0, 0, false, p), 0).unwrap();
        assert_eq!(mixer.streams().count(), 0);
        mixer.handle_message(&started(2, 0), 5).unwrap();
        assert_eq!(mixer.streams().count(), 1);
        mixer.render(&mut r, 20).unwrap();
    }

    #[test]
    fn orphans_expire() {
        let mut mixer = Mixer::new(JitterConfig::default());
        mixer
            .handle_voice(
                voice(3, 0, 0, false, Bytes::from_static(&[0xf8, 0xff, 0xfe])),
                0,
            )
            .unwrap();
        mixer
            .render(&mut PassthroughRenderer, ORPHAN_TIMEOUT_MS + 1)
            .unwrap();
        assert!(mixer.streams.is_empty());
    }

    #[test]
    fn soft_clip_bounds_output() {
        let mut s = vec![0.5, 0.9, 3.0, -10.0];
        soft_clip(&mut s);
        assert_eq!(s[0], 0.5);
        assert!(s[1] > 0.8 && s[1] < 1.0);
        assert!(s[2] <= 1.0 && s[3] >= -1.0);
    }
}
