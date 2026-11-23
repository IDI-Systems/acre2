//! How remote speakers and local sounds sound: the ACRE2Core effect chains, driven by the
//! parameters SQF sends (TS3-era `updateSpeakingData`, `updateSelf`, `playLoadedSound`).
//!
//! A speaker can reach us on several transmissions at once (direct and radio carry the same
//! voice), so only one stream per speaker is rendered: its *primary* (see [`crate::speakers`]).
//! That stream then feeds the speaker's direct channel and each radio that hears them, just as
//! the single TeamSpeak stream did.

use std::{
    collections::HashMap,
    sync::{Arc, Mutex},
};

use acre2_dsp::{
    effects::{BabbelEffect, RadioEffect, RadioParams, VolumeEffect},
    positional::{Attenuation, CurveModel, Emitter, Listener, Vec3, from_arma, stereo_gains},
};
use acre2_voice_codec::FrameKind;
use acre2_voice_proto::{PeerId, TxId};

use crate::meta::Meta;

/// How a speaker's direct channel is heard (`updateSpeakingData` types d/i/z/s/g).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum DirectKind {
    Direct,
    Intercom,
    Zeus,
    Spectate,
    God,
}

impl DirectKind {
    #[must_use]
    pub fn parse(s: &str) -> Option<Self> {
        Some(match s {
            "d" => Self::Direct,
            "i" => Self::Intercom,
            "z" => Self::Zeus,
            "s" => Self::Spectate,
            "g" => Self::God,
            _ => return None,
        })
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct DirectParams {
    pub kind: DirectKind,
    pub babel: bool,
    pub volume: f32,
    /// Arma ASL.
    pub position: Vec3,
    pub direction: Vec3,
}

/// One of our radios receiving the speaker.
#[derive(Debug, Clone, PartialEq)]
pub struct RadioOut {
    pub volume: f32,
    pub signal: f32,
    pub loudspeaker: bool,
    /// World position (Arma ASL) for loudspeakers; for headsets `[ear * 2, 0, 0]` with ear -1
    /// left, 0 both, 1 right.
    pub position: Vec3,
}

#[derive(Debug, Clone, Default, PartialEq)]
pub struct Speaker {
    /// The transmission currently rendered, and what it says about the speaker.
    pub primary: Option<(TxId, Meta)>,
    pub direct: Option<DirectParams>,
    pub radio_babel: bool,
    pub radios: Vec<RadioOut>,
    /// `updateSpeakingData` "m", or `speaker:mute`.
    pub muted: bool,
}

/// A sound playing locally (beeps, squelch).
#[derive(Debug)]
struct Playing {
    samples: Arc<[f32]>,
    pos: usize,
    gains: (f32, f32),
    volume: f32,
}

/// Everything the renderer reads, written by commands from SQF and by network events.
#[derive(Debug)]
pub struct RenderState {
    pub listener: Listener,
    pub curve_model: CurveModel,
    pub global_volume: f32,
    pub premix_volume: f32,
    pub radio_noise: bool,
    /// `setSoundSystemMasterOverride`: play everyone plainly, no ACRE processing.
    pub master_override: bool,
    pub speakers: HashMap<PeerId, Speaker>,
    pub sounds: HashMap<String, Arc<[f32]>>,
    playing: Vec<Playing>,
}

impl Default for RenderState {
    fn default() -> Self {
        Self {
            listener: Listener {
                position: [0.0; 3],
                front: [0.0, 0.0, 1.0],
            },
            curve_model: CurveModel::default(),
            global_volume: 1.0,
            premix_volume: 1.0,
            radio_noise: true,
            master_override: false,
            speakers: HashMap::new(),
            sounds: HashMap::new(),
            playing: Vec::new(),
        }
    }
}

impl RenderState {
    /// Starts a loaded sound. Returns false if it isn't loaded.
    pub fn play_sound(
        &mut self,
        id: &str,
        position: Vec3,
        direction: Vec3,
        volume: f32,
        world: bool,
    ) -> bool {
        let Some(samples) = self.sounds.get(id).cloned() else {
            return false;
        };
        let emitter = Emitter {
            position: from_arma(position),
            front: from_arma(direction),
        };
        let gains = if world {
            stereo_gains(self.listener, emitter, Attenuation::other(self.curve_model))
        } else {
            stereo_gains(
                Listener::HEADSET,
                emitter,
                Attenuation::direct(self.curve_model, 1.0),
            )
        };
        self.playing.push(Playing {
            samples,
            pos: 0,
            gains,
            volume,
        });
        true
    }
}

pub type SharedState = Arc<Mutex<RenderState>>;

/// Effect state for one channel.
#[derive(Debug, Default)]
struct ChannelDsp {
    babbel: BabbelEffect,
    radio: RadioEffect,
    volume: VolumeEffect,
}

#[derive(Debug, Default)]
struct SpeakerDsp {
    direct_kind: Option<DirectKind>,
    direct: ChannelDsp,
    radios: Vec<ChannelDsp>,
}

/// Plugs into the voice mixer.
#[derive(Debug)]
pub struct AcreRenderer {
    state: SharedState,
    dsp: HashMap<PeerId, SpeakerDsp>,
    buf: Vec<f32>,
}

impl AcreRenderer {
    #[must_use]
    pub fn new(state: SharedState) -> Self {
        Self {
            state,
            dsp: HashMap::new(),
            buf: Vec::new(),
        }
    }
}

impl acre2_voice_client::audio::Renderer for AcreRenderer {
    fn render(
        &mut self,
        info: &acre2_voice_client::audio::StreamInfo,
        _kind: FrameKind,
        mono: &mut [f32],
        out: &mut acre2_voice_client::audio::StereoFrame,
    ) {
        let st = self.state.lock().expect("render state");
        if st.master_override {
            out.add_mono(mono, 1.0, 1.0);
            return;
        }
        let Some(speaker) = st.speakers.get(&info.speaker) else {
            return;
        };
        let Some((primary, meta)) = &speaker.primary else {
            return;
        };
        if *primary != info.tx || speaker.muted {
            return;
        }
        for s in mono.iter_mut() {
            *s *= st.premix_volume;
        }
        let dsp = self.dsp.entry(info.speaker).or_default();

        if let Some(d) = &speaker.direct {
            // A change of kind starts the channel afresh, as ACRE2Core re-created it.
            if dsp.direct_kind != Some(d.kind) {
                dsp.direct_kind = Some(d.kind);
                dsp.direct = ChannelDsp::default();
            }
            self.buf.clear();
            self.buf.extend_from_slice(mono);
            if d.babel {
                dsp.direct.babbel.process(&mut self.buf);
            }
            if d.kind == DirectKind::Intercom {
                dsp.direct.radio.process(
                    &mut self.buf,
                    RadioParams {
                        signal_quality: 1.0,
                        noise: false,
                        loudspeaker: false,
                    },
                );
            }
            dsp.direct.volume.process(&mut self.buf, d.volume);
            let emitter = Emitter {
                position: from_arma(d.position),
                front: from_arma(d.direction),
            };
            let (l, r) = match d.kind {
                DirectKind::Direct | DirectKind::Zeus => stereo_gains(
                    st.listener,
                    emitter,
                    Attenuation::direct(st.curve_model, meta.curve_scale),
                ),
                DirectKind::Intercom => {
                    stereo_gains(st.listener, emitter, Attenuation::other(st.curve_model))
                }
                DirectKind::Spectate | DirectKind::God => (1.0, 1.0),
            };
            out.add_mono(&self.buf, l, r);
        }

        dsp.radios
            .resize_with(speaker.radios.len(), ChannelDsp::default);
        for (radio, ch) in speaker.radios.iter().zip(&mut dsp.radios) {
            self.buf.clear();
            self.buf.extend_from_slice(mono);
            if speaker.radio_babel {
                ch.babbel.process(&mut self.buf);
            }
            ch.radio.process(
                &mut self.buf,
                RadioParams {
                    signal_quality: radio.signal,
                    noise: st.radio_noise,
                    loudspeaker: radio.loudspeaker,
                },
            );
            ch.volume.process(&mut self.buf, radio.volume);
            let emitter = Emitter {
                position: from_arma(radio.position),
                front: [0.0, 0.0, 1.0],
            };
            let listener = if radio.loudspeaker {
                st.listener
            } else {
                Listener::HEADSET
            };
            let (l, r) = stereo_gains(listener, emitter, Attenuation::other(st.curve_model));
            out.add_mono(&self.buf, l, r);
        }
    }

    fn finish(&mut self, out: &mut acre2_voice_client::audio::StereoFrame) {
        let mut st = self.state.lock().expect("render state");
        let frame = out.left.len();
        st.playing.retain_mut(|p| {
            let end = (p.pos + frame).min(p.samples.len());
            for (i, s) in p.samples[p.pos..end].iter().enumerate() {
                out.left[i] += s * p.volume * p.gains.0;
                out.right[i] += s * p.volume * p.gains.1;
            }
            p.pos = end;
            p.pos < p.samples.len()
        });
        let g = st.global_volume;
        if (g - 1.0).abs() > f32::EPSILON {
            for s in out.left.iter_mut().chain(out.right.iter_mut()) {
                *s *= g;
            }
        }
    }

    fn stream_removed(&mut self, info: &acre2_voice_client::audio::StreamInfo) {
        let st = self.state.lock().expect("render state");
        if !st.speakers.contains_key(&info.speaker) {
            self.dsp.remove(&info.speaker);
        }
    }
}

#[cfg(test)]
mod tests {
    use acre2_voice_client::audio::{Renderer, StereoFrame, StreamInfo};

    use super::*;
    use crate::meta::speaking_type;

    fn meta() -> Meta {
        Meta {
            speaking_type: speaking_type::DIRECT,
            radio_id: String::new(),
            net_id: "1:2".into(),
            language_id: 0,
            curve_scale: 1.0,
        }
    }

    fn info(tx: u16) -> StreamInfo {
        StreamInfo {
            speaker: PeerId(7),
            speaker_external_id: "u".into(),
            tx: TxId(tx),
            matched: vec![],
            metadata: vec![],
        }
    }

    fn energy(x: &[f32]) -> f32 {
        x.iter().map(|s| s * s).sum()
    }

    fn setup(speaker: Speaker) -> (SharedState, AcreRenderer) {
        let state: SharedState = Arc::default();
        {
            let mut st = state.lock().unwrap();
            st.listener = Listener {
                position: from_arma([0.0, 0.0, 0.0]),
                front: from_arma([0.0, 1.0, 0.0]),
            };
            st.speakers.insert(PeerId(7), speaker);
        }
        let r = AcreRenderer::new(state.clone());
        (state, r)
    }

    fn render(r: &mut AcreRenderer, tx: u16) -> StereoFrame {
        let mut out = StereoFrame::new(960);
        let mut mono: Vec<f32> = (0..960).map(|i| 0.3 * (i as f32 * 0.07).sin()).collect();
        // Twice, so volume ramps from the default have settled.
        r.render(&info(tx), FrameKind::Audio, &mut mono.clone(), &mut out);
        out.clear();
        r.render(&info(tx), FrameKind::Audio, &mut mono, &mut out);
        out
    }

    #[test]
    fn silent_without_parameters() {
        let (_, mut r) = setup(Speaker {
            primary: Some((TxId(0), meta())),
            ..Speaker::default()
        });
        assert_eq!(energy(&render(&mut r, 0).left), 0.0);
    }

    #[test]
    fn direct_speaker_to_the_east_is_on_the_right() {
        let (_, mut r) = setup(Speaker {
            primary: Some((TxId(0), meta())),
            direct: Some(DirectParams {
                kind: DirectKind::Direct,
                babel: false,
                volume: 1.0,
                position: [3.0, 0.0, 0.0],
                direction: [-1.0, 0.0, 0.0],
            }),
            ..Speaker::default()
        });
        let out = render(&mut r, 0);
        assert!(energy(&out.right) > 10.0 * energy(&out.left));
    }

    #[test]
    fn only_the_primary_stream_renders() {
        let (_, mut r) = setup(Speaker {
            primary: Some((TxId(1), meta())),
            direct: Some(DirectParams {
                kind: DirectKind::Spectate,
                babel: false,
                volume: 1.0,
                position: [0.0; 3],
                direction: [0.0, 1.0, 0.0],
            }),
            ..Speaker::default()
        });
        assert_eq!(energy(&render(&mut r, 0).left), 0.0);
        assert!(energy(&render(&mut r, 1).left) > 0.0);
    }

    #[test]
    fn headset_radio_in_left_ear() {
        let (_, mut r) = setup(Speaker {
            primary: Some((TxId(1), meta())),
            radios: vec![RadioOut {
                volume: 1.0,
                signal: 1.0,
                loudspeaker: false,
                position: [-2.0, 0.0, 0.0],
            }],
            ..Speaker::default()
        });
        let out = render(&mut r, 1);
        assert!(energy(&out.left) > 0.1);
        assert!(energy(&out.right) < energy(&out.left) * 0.01);
    }

    #[test]
    fn muted_and_override() {
        let (state, mut r) = setup(Speaker {
            primary: Some((TxId(0), meta())),
            direct: Some(DirectParams {
                kind: DirectKind::God,
                babel: false,
                volume: 1.0,
                position: [0.0; 3],
                direction: [0.0, 1.0, 0.0],
            }),
            muted: true,
            ..Speaker::default()
        });
        assert_eq!(energy(&render(&mut r, 0).left), 0.0);
        state.lock().unwrap().master_override = true;
        assert!(energy(&render(&mut r, 0).left) > 0.0);
    }

    #[test]
    fn sounds_play_to_the_end() {
        let state: SharedState = Arc::default();
        state
            .lock()
            .unwrap()
            .sounds
            .insert("beep".into(), Arc::from(vec![0.5f32; 1500]));
        assert!(
            state
                .lock()
                .unwrap()
                .play_sound("beep", [0.0; 3], [0.0, 1.0, 0.0], 1.0, false)
        );
        assert!(
            !state
                .lock()
                .unwrap()
                .play_sound("nope", [0.0; 3], [0.0, 1.0, 0.0], 1.0, false)
        );
        let mut r = AcreRenderer::new(state.clone());
        let mut out = StereoFrame::new(960);
        r.finish(&mut out);
        assert!(out.left[959] > 0.0);
        out.clear();
        r.finish(&mut out);
        assert!(out.left[539] > 0.0 && out.left[540] == 0.0);
        out.clear();
        r.finish(&mut out);
        assert_eq!(energy(&out.left), 0.0);
        assert!(state.lock().unwrap().playing.is_empty());
    }
}
