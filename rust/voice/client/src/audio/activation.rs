//! Microphone gating: voice activation with hangover, push-to-talk, and the rule that any held
//! PTT opens the mic.

/// How direct speech is triggered when no PTT is held.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub enum ActivationMode {
    /// Transmit while the input level is above the threshold.
    #[default]
    Voice,
    /// Transmit only while the direct-speech PTT key is held.
    PushToTalk,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct ActivationConfig {
    pub mode: ActivationMode,
    /// Level (dBFS, RMS of a frame) that opens voice activation. Typical speech is -30 to -10.
    pub open_db: f32,
    /// Level it must fall below before closing (after the hangover). At most `open_db`; the gap
    /// keeps quiet syllables from chopping.
    pub close_db: f32,
    /// How long voice activation stays open after the level drops, so word gaps don't cut out.
    pub hangover_ms: u32,
}

impl Default for ActivationConfig {
    fn default() -> Self {
        Self {
            mode: ActivationMode::Voice,
            open_db: -45.0,
            close_db: -50.0,
            hangover_ms: 400,
        }
    }
}

/// RMS level of a frame in dBFS, floored at -100.
#[must_use]
pub fn level_db(frame: &[f32]) -> f32 {
    if frame.is_empty() {
        return -100.0;
    }
    let mean_sq = frame.iter().map(|s| s * s).sum::<f32>() / frame.len() as f32;
    if mean_sq <= 1e-10 {
        -100.0
    } else {
        (10.0 * mean_sq.log10()).max(-100.0)
    }
}

/// Speech probability (from [`Denoiser`](super::Denoiser)) a frame needs to count as speech
/// when speech detection is on.
pub const SPEECH_OPEN: f32 = 0.5;
/// Consecutive speech frames needed to open: a single loud click can briefly look like speech,
/// a word doesn't stop after 20 ms.
pub const SPEECH_FRAMES: u8 = 2;

/// Voice-activation detector with hangover.
#[derive(Debug, Clone)]
pub struct VoiceGate {
    config: ActivationConfig,
    /// Above the close level since opening.
    open: bool,
    remaining_ms: u32,
    /// Consecutive frames that sounded like speech.
    speech_run: u8,
}

impl VoiceGate {
    #[must_use]
    pub fn new(config: ActivationConfig) -> Self {
        Self {
            config,
            open: false,
            remaining_ms: 0,
            speech_run: 0,
        }
    }

    #[must_use]
    pub fn config(&self) -> ActivationConfig {
        self.config
    }

    pub fn set_config(&mut self, config: ActivationConfig) {
        self.config = config;
    }

    /// Feeds one frame's level and returns whether voice activation is open.
    pub fn update(&mut self, level_db: f32, frame_ms: u32) -> bool {
        self.update_with_speech(level_db, None, frame_ms)
    }

    /// Like [`update`](Self::update), with speech detection: given the frame's speech
    /// probability, opening also needs [`SPEECH_FRAMES`] frames in a row of at least
    /// [`SPEECH_OPEN`] (staying open, once talking, only needs the level).
    pub fn update_with_speech(
        &mut self,
        level_db: f32,
        speech: Option<f32>,
        frame_ms: u32,
    ) -> bool {
        let close_db = self.config.close_db.min(self.config.open_db);
        let is_speech = match speech {
            None => true,
            Some(p) => {
                self.speech_run = if p >= SPEECH_OPEN {
                    self.speech_run.saturating_add(1)
                } else {
                    0
                };
                self.speech_run >= SPEECH_FRAMES
            }
        };
        let opens = level_db >= self.config.open_db && is_speech;
        if opens || (self.open && level_db >= close_db) {
            self.open = true;
            self.remaining_ms = self.config.hangover_ms.max(frame_ms);
            true
        } else if self.remaining_ms > 0 {
            self.open = false;
            self.remaining_ms = self.remaining_ms.saturating_sub(frame_ms);
            true
        } else {
            false
        }
    }

    /// Whether direct speech should be sent this frame.
    ///
    /// Any held PTT (direct or keyed transmissions such as radios) forces the mic open;
    /// otherwise voice activation decides, if that's the mode.
    pub fn direct_open(
        &mut self,
        level_db: f32,
        speech: Option<f32>,
        frame_ms: u32,
        direct_ptt: bool,
        any_keyed: bool,
    ) -> bool {
        let voice = self.update_with_speech(level_db, speech, frame_ms);
        direct_ptt || any_keyed || (self.config.mode == ActivationMode::Voice && voice)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn level_of_known_signals() {
        assert_eq!(level_db(&[0.0; 960]), -100.0);
        assert!((level_db(&[1.0; 960]) - 0.0).abs() < 0.01);
        assert!((level_db(&[0.1; 960]) + 20.0).abs() < 0.01);
    }

    #[test]
    fn hangover_keeps_gate_open() {
        let mut g = VoiceGate::new(ActivationConfig {
            hangover_ms: 60,
            ..ActivationConfig::default()
        });
        assert!(g.update(-20.0, 20));
        assert!(g.update(-80.0, 20));
        assert!(g.update(-80.0, 20));
        assert!(g.update(-80.0, 20));
        assert!(!g.update(-80.0, 20));
    }

    #[test]
    fn ptt_mode_ignores_voice() {
        let mut g = VoiceGate::new(ActivationConfig {
            mode: ActivationMode::PushToTalk,
            ..ActivationConfig::default()
        });
        assert!(!g.direct_open(-10.0, None, 20, false, false));
        assert!(g.direct_open(-100.0, None, 20, true, false));
    }

    #[test]
    fn any_keyed_ptt_opens_mic() {
        let mut g = VoiceGate::new(ActivationConfig::default());
        assert!(!g.direct_open(-100.0, None, 20, false, false));
        assert!(g.direct_open(-100.0, None, 20, false, true));
    }

    #[test]
    fn speech_detection_keeps_loud_noise_out() {
        let mut g = VoiceGate::new(ActivationConfig {
            open_db: -30.0,
            close_db: -40.0,
            hangover_ms: 20,
            ..ActivationConfig::default()
        });
        assert!(
            !g.update_with_speech(-10.0, Some(0.05), 20),
            "loud click: closed"
        );
        assert!(
            !g.update_with_speech(-10.0, Some(0.7), 20),
            "one speech-like frame isn't enough"
        );
        assert!(!g.update_with_speech(-10.0, Some(0.1), 20));
        assert!(!g.update_with_speech(-20.0, Some(0.9), 20));
        assert!(g.update_with_speech(-20.0, Some(0.9), 20), "speech opens");
        assert!(
            g.update_with_speech(-35.0, Some(0.1), 20),
            "a quiet syllable while talking keeps it open"
        );
    }

    #[test]
    fn stays_open_between_close_and_open_levels() {
        let mut g = VoiceGate::new(ActivationConfig {
            open_db: -30.0,
            close_db: -40.0,
            hangover_ms: 20,
            ..ActivationConfig::default()
        });
        assert!(!g.update(-35.0, 20), "below open: stays closed");
        assert!(g.update(-25.0, 20), "opens");
        assert!(g.update(-35.0, 20), "between: stays open");
        assert!(g.update(-38.0, 20), "still above close");
        assert!(g.update(-45.0, 20), "below close: hangover");
        assert!(!g.update(-45.0, 20), "closed");
        assert!(!g.update(-35.0, 20), "needs the open level again");
    }
}
