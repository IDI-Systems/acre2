//! Turns per-transmission server events into ACRE's per-speaker speaking state.
//!
//! In ACRE a speaker is in one state at a time (direct, or radio on one radio, intercom, god,
//! zeus), and SQF expects `remoteStartSpeaking`/`remoteStopSpeaking` for changes of that state.
//! A speaker's transmissions are merged: the highest transmission id wins (keyed transmissions
//! use ids above direct's 0), which also picks the stream the renderer plays.

use std::collections::{BTreeMap, HashMap};

use acre2_voice_proto::{PeerId, TxId};

use crate::{meta::Meta, render::RenderState};

#[derive(Debug, Clone, PartialEq)]
pub enum SpeakingEvent {
    Start { peer: PeerId, meta: Meta },
    Stop { peer: PeerId, meta: Meta },
}

#[derive(Debug, Default)]
pub struct Tracker {
    active: HashMap<PeerId, BTreeMap<TxId, Meta>>,
}

impl Tracker {
    pub fn started(
        &mut self,
        state: &mut RenderState,
        peer: PeerId,
        tx: TxId,
        metadata: &[u8],
    ) -> Vec<SpeakingEvent> {
        let Some(meta) = Meta::decode(metadata) else {
            tracing::warn!(%peer, "transmission without ACRE metadata, ignored");
            return Vec::new();
        };
        self.active.entry(peer).or_default().insert(tx, meta);
        self.recompute(state, peer)
    }

    pub fn ended(&mut self, state: &mut RenderState, peer: PeerId, tx: TxId) -> Vec<SpeakingEvent> {
        if let Some(a) = self.active.get_mut(&peer) {
            a.remove(&tx);
            if a.is_empty() {
                self.active.remove(&peer);
            }
        }
        self.recompute(state, peer)
    }

    /// Forgets everyone (disconnected), returning stops for whoever was speaking.
    pub fn clear(&mut self, state: &mut RenderState) -> Vec<SpeakingEvent> {
        self.active.clear();
        state
            .speakers
            .drain()
            .filter_map(|(peer, s)| {
                s.primary
                    .map(|(_, meta)| SpeakingEvent::Stop { peer, meta })
            })
            .collect()
    }

    fn recompute(&mut self, state: &mut RenderState, peer: PeerId) -> Vec<SpeakingEvent> {
        let new = self
            .active
            .get(&peer)
            .and_then(|a| a.last_key_value())
            .map(|(tx, m)| (*tx, m.clone()));
        let old = state.speakers.get(&peer).and_then(|s| s.primary.clone());
        match (old, new) {
            (None, None) => Vec::new(),
            (Some((otx, om)), Some((ntx, nm))) if otx == ntx && om.same_state(&nm) => {
                // Only the curve scale changed.
                if let Some(s) = state.speakers.get_mut(&peer) {
                    s.primary = Some((ntx, nm));
                }
                Vec::new()
            }
            (old, new) => {
                let mut events = Vec::new();
                if let Some((_, meta)) = old {
                    // Like ACRE2Core deleting the player: SQF sends fresh parameters.
                    state.speakers.remove(&peer);
                    events.push(SpeakingEvent::Stop { peer, meta });
                }
                if let Some((tx, meta)) = new {
                    state.speakers.entry(peer).or_default().primary = Some((tx, meta.clone()));
                    events.push(SpeakingEvent::Start { peer, meta });
                }
                events
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::meta::speaking_type;

    fn meta(t: u8, radio: &str, scale: f32) -> Meta {
        Meta {
            speaking_type: t,
            radio_id: radio.into(),
            net_id: "2:1".into(),
            language_id: 0,
            curve_scale: scale,
        }
    }

    const P: PeerId = PeerId(3);

    #[test]
    fn direct_then_radio_then_back() {
        let mut t = Tracker::default();
        let mut st = RenderState::default();
        let direct = meta(speaking_type::DIRECT, "", 1.0);
        let radio = meta(speaking_type::RADIO, "r1", 1.0);

        let ev = t.started(&mut st, P, TxId(0), &direct.encode());
        assert_eq!(
            ev,
            vec![SpeakingEvent::Start {
                peer: P,
                meta: direct.clone()
            }]
        );

        let ev = t.started(&mut st, P, TxId(1), &radio.encode());
        assert_eq!(
            ev,
            vec![
                SpeakingEvent::Stop {
                    peer: P,
                    meta: direct.clone()
                },
                SpeakingEvent::Start {
                    peer: P,
                    meta: radio.clone()
                }
            ]
        );
        assert_eq!(st.speakers[&P].primary.as_ref().unwrap().0, TxId(1));

        // Direct ending underneath changes nothing.
        assert!(t.ended(&mut st, P, TxId(0)).is_empty());
        let ev = t.ended(&mut st, P, TxId(1));
        assert_eq!(
            ev,
            vec![SpeakingEvent::Stop {
                peer: P,
                meta: radio
            }]
        );
        assert!(!st.speakers.contains_key(&P));
    }

    #[test]
    fn curve_scale_change_is_silent() {
        let mut t = Tracker::default();
        let mut st = RenderState::default();
        t.started(
            &mut st,
            P,
            TxId(0),
            &meta(speaking_type::DIRECT, "", 1.0).encode(),
        );
        assert!(
            t.started(
                &mut st,
                P,
                TxId(0),
                &meta(speaking_type::DIRECT, "", 0.4).encode()
            )
            .is_empty()
        );
        assert_eq!(st.speakers[&P].primary.as_ref().unwrap().1.curve_scale, 0.4);
    }

    #[test]
    fn bad_metadata_is_ignored() {
        let mut t = Tracker::default();
        let mut st = RenderState::default();
        assert!(t.started(&mut st, P, TxId(0), b"\xff\xff\xff").is_empty());
    }

    #[test]
    fn clear_stops_everyone() {
        let mut t = Tracker::default();
        let mut st = RenderState::default();
        t.started(
            &mut st,
            P,
            TxId(0),
            &meta(speaking_type::DIRECT, "", 1.0).encode(),
        );
        assert_eq!(t.clear(&mut st).len(), 1);
        assert!(st.speakers.is_empty());
    }
}
