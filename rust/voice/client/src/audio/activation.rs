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
    /// Voice activation threshold in dBFS (RMS of a frame). Typical speech is -30 to -10.
    pub threshold_db: f32,
    /// How long voice activation stays open after the level drops, so word gaps don't cut out.
    pub hangover_ms: u32,
}

impl Default for ActivationConfig {
    fn default() -> Self {
        Self {
            mode: ActivationMode::Voice,
            threshold_db: -45.0,
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

/// Voice-activation detector with hangover.
#[derive(Debug, Clone)]
pub struct VoiceGate {
    config: ActivationConfig,
    remaining_ms: u32,
}

impl VoiceGate {
    #[must_use]
    pub fn new(config: ActivationConfig) -> Self {
        Self {
            config,
            remaining_ms: 0,
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
        if level_db >= self.config.threshold_db {
            self.remaining_ms = self.config.hangover_ms.max(frame_ms);
            true
        } else if self.remaining_ms > 0 {
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
        frame_ms: u32,
        direct_ptt: bool,
        any_keyed: bool,
    ) -> bool {
        let voice = self.update(level_db, frame_ms);
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
        assert!(!g.direct_open(-10.0, 20, false, false));
        assert!(g.direct_open(-100.0, 20, true, false));
    }

    #[test]
    fn any_keyed_ptt_opens_mic() {
        let mut g = VoiceGate::new(ActivationConfig::default());
        assert!(!g.direct_open(-100.0, 20, false, false));
        assert!(g.direct_open(-100.0, 20, false, true));
    }
}
