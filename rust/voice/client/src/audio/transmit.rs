//! Turns microphone frames into transmission control messages and voice packets.
//!
//! Device-free: feed it 48 kHz mono frames, apply the [`TxAction`]s it returns.

use std::collections::{BTreeMap, BTreeSet, VecDeque};

use acre2_voice_codec::{CodecError, EncoderConfig, VoiceEncoder};
use acre2_voice_proto::{Target, TxId, datagram::flags};
use bytes::Bytes;

use super::{
    activation::{ActivationConfig, SPEECH_FRAMES, VoiceGate, level_db},
    denoise::{Denoiser, NoiseConfig},
};

/// Transmission id used for direct (voice-activated or direct-PTT) speech. Keyed transmissions
/// must use other ids.
pub const DIRECT_TX: TxId = TxId(0);

/// Where a transmission goes and what listeners are told about it.
#[derive(Debug, Clone, PartialEq)]
pub struct Outgoing {
    pub targets: Vec<Target>,
    pub metadata: Vec<u8>,
}

/// Something to send.
#[derive(Debug, Clone, PartialEq)]
pub enum TxAction {
    Start {
        tx: TxId,
        targets: Vec<Target>,
        metadata: Vec<u8>,
    },
    Voice {
        tx: TxId,
        seq: u16,
        flags: u8,
        payload: Bytes,
    },
    Stop {
        tx: TxId,
    },
}

#[derive(Debug)]
#[allow(clippy::struct_excessive_bools)]
pub struct Transmitter {
    encoder: VoiceEncoder,
    frame_ms: u32,
    gate: VoiceGate,
    direct: Option<Outgoing>,
    direct_ptt: bool,
    keyed: BTreeMap<TxId, Outgoing>,
    /// Started on the server, with the next sequence number.
    active: BTreeMap<TxId, u16>,
    /// Next sequence number of stopped transmissions. Sequence numbers carry on across talk
    /// spurts so listeners' jitter buffers don't mistake a restart for late packets.
    next_seq: BTreeMap<TxId, u16>,
    /// Active transmissions whose definition changed and must be re-announced.
    changed: BTreeSet<TxId>,
    muted: bool,
    exclusive: bool,
    level_db: f32,
    mic_open: bool,
    noise: NoiseConfig,
    denoiser: Denoiser,
    /// The frame being processed, after the noise filter.
    filtered: Vec<f32>,
    speech: f32,
    /// The last frames before talking started, while speech detection is on: it needs a few
    /// frames to recognise speech, and these are sent first so the start of a word isn't lost.
    preroll: VecDeque<Vec<f32>>,
    /// Transmissions also played back to ourselves (see [`Transmitter::set_loopback`]).
    loopback: BTreeSet<TxId>,
}

impl Transmitter {
    pub fn new(encoder: EncoderConfig, activation: ActivationConfig) -> Result<Self, CodecError> {
        Ok(Self {
            frame_ms: encoder.frame_ms,
            encoder: VoiceEncoder::new(encoder)?,
            gate: VoiceGate::new(activation),
            direct: None,
            direct_ptt: false,
            keyed: BTreeMap::new(),
            active: BTreeMap::new(),
            next_seq: BTreeMap::new(),
            changed: BTreeSet::new(),
            muted: false,
            exclusive: false,
            level_db: -100.0,
            mic_open: false,
            noise: NoiseConfig::default(),
            denoiser: Denoiser::new(),
            filtered: Vec::new(),
            speech: 0.0,
            preroll: VecDeque::new(),
            loopback: BTreeSet::new(),
        })
    }

    #[must_use]
    pub fn frame_samples(&self) -> usize {
        self.encoder.frame_samples()
    }

    pub fn set_activation(&mut self, config: ActivationConfig) {
        self.gate.set_config(config);
    }

    #[must_use]
    pub fn activation(&self) -> ActivationConfig {
        self.gate.config()
    }

    /// Sets (or clears) where direct speech goes. Takes effect the next time direct speech
    /// starts, or immediately (re-announced) if it's running.
    pub fn set_direct(&mut self, direct: Option<Outgoing>) {
        if direct.is_some() && direct != self.direct && self.active.contains_key(&DIRECT_TX) {
            self.changed.insert(DIRECT_TX);
        }
        self.direct = direct;
    }

    pub fn set_direct_ptt(&mut self, pressed: bool) {
        self.direct_ptt = pressed;
    }

    /// Presses a PTT for a keyed transmission (radio, intercom, …), or updates one that's held.
    pub fn key(&mut self, tx: TxId, outgoing: Outgoing) {
        assert_ne!(tx, DIRECT_TX, "TxId(0) is reserved for direct speech");
        if self.active.contains_key(&tx) && self.keyed.get(&tx) != Some(&outgoing) {
            self.changed.insert(tx);
        }
        self.keyed.insert(tx, outgoing);
    }

    /// Releases a keyed transmission.
    pub fn unkey(&mut self, tx: TxId) {
        self.keyed.remove(&tx);
    }

    /// Also plays a transmission back to ourselves, e.g. to hear yourself on a second radio tuned
    /// to the one you transmit on. A [`super::VoiceSession`] delivers its start, voice and end to
    /// its own mixer and events like a remote transmission, with our own peer id as the speaker.
    /// Takes effect from the next start of the transmission.
    pub fn set_loopback(&mut self, tx: TxId, on: bool) {
        if on {
            self.loopback.insert(tx);
        } else {
            self.loopback.remove(&tx);
        }
    }

    #[must_use]
    pub fn loops_back(&self, tx: TxId) -> bool {
        self.loopback.contains(&tx)
    }

    /// Exclusive mode: while any keyed transmission is held, direct speech isn't sent (the keyed
    /// transmission's own targets should then cover nearby listeners). Off by default, where a
    /// held key sends on its own transmission *and* direct speech.
    pub fn set_exclusive(&mut self, exclusive: bool) {
        self.exclusive = exclusive;
    }

    /// Sets the microphone filter (noise suppression, speech detection for voice activation).
    pub fn set_noise(&mut self, noise: NoiseConfig) {
        if noise.active() && !self.noise.active() {
            // Don't resume from whatever it heard when last used.
            self.denoiser = Denoiser::new();
        }
        self.noise = noise;
    }

    #[must_use]
    pub fn noise(&self) -> NoiseConfig {
        self.noise
    }

    /// Speech probability of the last frame (0 while the filter is off).
    #[must_use]
    pub fn speech_probability(&self) -> f32 {
        self.speech
    }

    /// Mutes the microphone: nothing is sent, but PTT state is kept.
    pub fn set_muted(&mut self, muted: bool) {
        self.muted = muted;
    }

    /// Level of the last frame, in dBFS (after noise suppression, if on).
    #[must_use]
    pub fn level_db(&self) -> f32 {
        self.level_db
    }

    /// Whether anything was sent for the last frame.
    #[must_use]
    pub fn is_transmitting(&self) -> bool {
        self.mic_open
    }

    #[must_use]
    pub fn is_active(&self, tx: TxId) -> bool {
        self.active.contains_key(&tx)
    }

    /// Processes one frame of 48 kHz mono audio.
    pub fn process(&mut self, frame: &[f32]) -> Result<Vec<TxAction>, CodecError> {
        self.filtered.clear();
        self.filtered.extend_from_slice(frame);
        let speech = if self.noise.active() {
            self.speech = self
                .denoiser
                .process(&mut self.filtered, self.noise.suppress);
            Some(self.speech)
        } else {
            self.speech = 0.0;
            None
        };
        self.level_db = level_db(&self.filtered);
        let direct_open = self.gate.direct_open(
            self.level_db,
            speech.filter(|_| self.noise.speech_gate),
            self.frame_ms,
            self.direct_ptt,
            !self.keyed.is_empty(),
        );

        // What should be running this frame.
        let mut want: BTreeMap<TxId, &Outgoing> = BTreeMap::new();
        if !self.muted {
            let suppressed = self.exclusive && !self.keyed.is_empty();
            if let (true, false, Some(direct)) = (direct_open, suppressed, &self.direct) {
                want.insert(DIRECT_TX, direct);
            }
            for (tx, o) in &self.keyed {
                want.insert(*tx, o);
            }
        }

        let mut actions = Vec::new();
        let stopping: Vec<TxId> = self
            .active
            .keys()
            .filter(|tx| !want.contains_key(tx))
            .copied()
            .collect();
        if want.is_empty() && stopping.is_empty() {
            self.mic_open = false;
            if self.noise.speech_gate && !self.muted {
                self.preroll.push_back(self.filtered.clone());
                while self.preroll.len() > usize::from(SPEECH_FRAMES) {
                    self.preroll.pop_front();
                }
            } else {
                self.preroll.clear();
            }
            return Ok(actions);
        }
        let mut payloads = Vec::new();
        if !self.mic_open && !want.is_empty() {
            // New talk spurt: no state carried over from the last one.
            self.encoder.reset()?;
            for f in std::mem::take(&mut self.preroll) {
                payloads.push(self.encoder.encode(&f)?);
            }
        }
        self.preroll.clear();

        for (tx, o) in &want {
            if !self.active.contains_key(tx) || self.changed.contains(tx) {
                actions.push(TxAction::Start {
                    tx: *tx,
                    targets: o.targets.clone(),
                    metadata: o.metadata.clone(),
                });
                let seq = self.next_seq.get(tx).copied().unwrap_or(0);
                self.active.entry(*tx).or_insert(seq);
            }
        }
        self.changed.clear();

        payloads.push(self.encoder.encode(&self.filtered)?);
        for (tx, seq) in &mut self.active {
            let stops = stopping.contains(tx);
            for (i, payload) in payloads.iter().enumerate() {
                let last = stops && i + 1 == payloads.len();
                actions.push(TxAction::Voice {
                    tx: *tx,
                    seq: *seq,
                    flags: if last { flags::END_OF_SPURT } else { 0 },
                    payload: payload.clone(),
                });
                *seq = seq.wrapping_add(1);
            }
        }
        for tx in stopping {
            if let Some(seq) = self.active.remove(&tx) {
                self.next_seq.insert(tx, seq);
            }
            actions.push(TxAction::Stop { tx });
        }
        self.mic_open = !want.is_empty();
        Ok(actions)
    }
}

#[cfg(test)]
mod tests {
    use acre2_voice_codec::FRAME_SAMPLES;
    use acre2_voice_proto::ChannelKey;

    use super::*;
    use crate::audio::ActivationMode;

    fn tx() -> Transmitter {
        let mut t = Transmitter::new(
            EncoderConfig::default(),
            ActivationConfig {
                hangover_ms: 40,
                ..ActivationConfig::default()
            },
        )
        .unwrap();
        t.set_direct(Some(Outgoing {
            targets: vec![Target::Spatial { range: 30.0 }],
            metadata: vec![],
        }));
        t
    }

    fn loud() -> Vec<f32> {
        (0..FRAME_SAMPLES)
            .map(|i| if i % 20 < 10 { 0.3 } else { -0.3 })
            .collect()
    }

    fn quiet() -> Vec<f32> {
        vec![0.0; FRAME_SAMPLES]
    }

    fn radio() -> Outgoing {
        Outgoing {
            targets: vec![Target::Channel(ChannelKey::new("radio:1").unwrap())],
            metadata: b"prc152".to_vec(),
        }
    }

    fn kinds(actions: &[TxAction]) -> Vec<String> {
        actions
            .iter()
            .map(|a| match a {
                TxAction::Start { tx, .. } => format!("start{}", tx.0),
                TxAction::Voice { tx, seq, flags, .. } => {
                    format!("voice{}#{seq}{}", tx.0, if *flags != 0 { "!" } else { "" })
                }
                TxAction::Stop { tx } => format!("stop{}", tx.0),
            })
            .collect()
    }

    #[test]
    fn voice_activation_spurt() {
        let mut t = tx();
        assert!(t.process(&quiet()).unwrap().is_empty());
        assert_eq!(kinds(&t.process(&loud()).unwrap()), ["start0", "voice0#0"]);
        assert_eq!(kinds(&t.process(&quiet()).unwrap()), ["voice0#1"]); // hangover
        assert_eq!(kinds(&t.process(&quiet()).unwrap()), ["voice0#2"]);
        assert_eq!(kinds(&t.process(&quiet()).unwrap()), ["voice0#3!", "stop0"]);
        assert!(t.process(&quiet()).unwrap().is_empty());
        assert!(!t.is_transmitting());
    }

    #[test]
    fn radio_ptt_opens_mic_and_sends_direct_too() {
        let mut t = tx();
        t.key(TxId(5), radio());
        assert_eq!(
            kinds(&t.process(&quiet()).unwrap()),
            ["start0", "start5", "voice0#0", "voice5#0"]
        );
        t.unkey(TxId(5));
        assert_eq!(
            kinds(&t.process(&quiet()).unwrap()),
            ["voice0#1!", "voice5#1!", "stop0", "stop5"]
        );
    }

    #[test]
    fn ptt_mode() {
        let mut t = tx();
        t.set_activation(ActivationConfig {
            mode: ActivationMode::PushToTalk,
            ..ActivationConfig::default()
        });
        assert!(t.process(&loud()).unwrap().is_empty());
        t.set_direct_ptt(true);
        assert_eq!(kinds(&t.process(&quiet()).unwrap()), ["start0", "voice0#0"]);
        t.set_direct_ptt(false);
        assert_eq!(kinds(&t.process(&loud()).unwrap()), ["voice0#1!", "stop0"]);
    }

    #[test]
    fn changing_direct_while_talking_reannounces() {
        let mut t = tx();
        t.process(&loud()).unwrap();
        t.set_direct(Some(Outgoing {
            targets: vec![Target::Spatial { range: 80.0 }],
            metadata: vec![1],
        }));
        assert_eq!(kinds(&t.process(&loud()).unwrap()), ["start0", "voice0#1"]);
    }

    #[test]
    fn exclusive_mode_swaps_direct_for_keyed() {
        let mut t = tx();
        t.set_exclusive(true);
        assert_eq!(kinds(&t.process(&loud()).unwrap()), ["start0", "voice0#0"]);
        t.key(TxId(5), radio());
        assert_eq!(
            kinds(&t.process(&loud()).unwrap()),
            ["start5", "voice0#1!", "voice5#0", "stop0"]
        );
        t.unkey(TxId(5));
        assert_eq!(
            kinds(&t.process(&loud()).unwrap()),
            ["start0", "voice0#2", "voice5#1!", "stop5"]
        );
    }

    #[test]
    fn muted_sends_nothing() {
        let mut t = tx();
        t.set_muted(true);
        t.key(TxId(1), radio());
        assert!(t.process(&loud()).unwrap().is_empty());
    }

    #[test]
    fn speech_detection_sends_the_frames_before_it_opened() {
        let mut t = tx();
        t.set_noise(NoiseConfig {
            suppress: false,
            speech_gate: true,
        });
        for _ in 0..5 {
            assert!(t.process(&quiet()).unwrap().is_empty());
        }
        // A PTT press stands in for the moment voice activation recognises speech.
        t.set_direct_ptt(true);
        let n = usize::from(SPEECH_FRAMES);
        let mut want = vec!["start0".to_string()];
        want.extend((0..=n).map(|i| format!("voice0#{i}")));
        assert_eq!(
            kinds(&t.process(&loud()).unwrap()),
            want,
            "the last {n} idle frames lead the spurt"
        );
        assert_eq!(
            kinds(&t.process(&loud()).unwrap()),
            [format!("voice0#{}", n + 1)]
        );
    }

    #[test]
    #[should_panic(expected = "reserved")]
    fn direct_id_is_reserved() {
        tx().key(DIRECT_TX, radio());
    }
}
