//! Our own transmissions played back to ourselves ([`super::Transmitter::set_loopback`]).
//!
//! The server never sends a speaker their own voice, so the session copies the transmitter's
//! actions for looped transmissions into what a remote transmission would look like: control
//! messages and voice frames from our own peer id.

use std::collections::BTreeSet;

use acre2_voice_proto::{ExternalId, PeerId, ServerMsg, TxId, datagram::ServerVoice};

use super::{Transmitter, TxAction};

/// What to deliver locally, as if received from the server.
#[derive(Debug, Clone, PartialEq)]
pub enum Looped {
    Message(ServerMsg),
    Voice(ServerVoice),
}

/// Tracks which of our transmissions are being looped back.
#[derive(Debug, Default)]
pub struct Loopback {
    playing: BTreeSet<TxId>,
}

impl Loopback {
    /// The local copies of `actions` (just returned by `t`'s `process`).
    pub fn copy(
        &mut self,
        t: &Transmitter,
        actions: &[TxAction],
        me: PeerId,
        external_id: &str,
    ) -> Vec<Looped> {
        let mut out = Vec::new();
        for a in actions {
            match a {
                TxAction::Start { tx, metadata, .. } => {
                    if t.loops_back(*tx) {
                        self.playing.insert(*tx);
                        out.push(Looped::Message(ServerMsg::TransmissionStarted {
                            speaker: me,
                            speaker_external_id: ExternalId::from(external_id),
                            tx: *tx,
                            matched: Vec::new(),
                            metadata: metadata.clone(),
                        }));
                    } else if self.playing.remove(tx) {
                        // Re-announced without loopback: stop hearing it.
                        out.push(Looped::Message(ServerMsg::TransmissionEnded {
                            speaker: me,
                            tx: *tx,
                        }));
                    }
                }
                TxAction::Voice {
                    tx,
                    seq,
                    flags,
                    payload,
                } if self.playing.contains(tx) => out.push(Looped::Voice(ServerVoice {
                    speaker: me,
                    tx: *tx,
                    seq: *seq,
                    flags: *flags,
                    payload: payload.clone(),
                })),
                TxAction::Voice { .. } => {}
                TxAction::Stop { tx } => {
                    if self.playing.remove(tx) {
                        out.push(Looped::Message(ServerMsg::TransmissionEnded {
                            speaker: me,
                            tx: *tx,
                        }));
                    }
                }
            }
        }
        out
    }
}

#[cfg(test)]
mod tests {
    use acre2_voice_codec::{EncoderConfig, FRAME_SAMPLES};
    use acre2_voice_proto::Target;

    use super::*;
    use crate::audio::{ActivationConfig, ActivationMode, Outgoing};

    const ME: PeerId = PeerId(4);

    fn tx() -> Transmitter {
        let mut t = Transmitter::new(
            EncoderConfig::default(),
            ActivationConfig {
                mode: ActivationMode::PushToTalk,
                ..ActivationConfig::default()
            },
        )
        .unwrap();
        t.set_direct(Some(Outgoing {
            targets: vec![Target::Spatial { range: 30.0 }],
            metadata: vec![0],
        }));
        t
    }

    fn radio() -> Outgoing {
        Outgoing {
            targets: vec![Target::Channel(
                acre2_voice_proto::ChannelKey::new("radio:43.1").unwrap(),
            )],
            metadata: vec![1],
        }
    }

    fn tone() -> Vec<f32> {
        (0..FRAME_SAMPLES)
            .map(|i| (i as f32 * 0.05).sin() * 0.3)
            .collect()
    }

    fn step(t: &mut Transmitter, l: &mut Loopback) -> Vec<Looped> {
        let actions = t.process(&tone()).unwrap();
        l.copy(t, &actions, ME, "me")
    }

    #[test]
    fn only_looped_transmissions_come_back() {
        let (mut t, mut l) = (tx(), Loopback::default());
        t.set_loopback(TxId(1), true);
        t.key(TxId(1), radio());
        // Radio PTT also sends direct speech; only the radio comes back.
        let first = step(&mut t, &mut l);
        assert!(matches!(
            &first[0],
            Looped::Message(ServerMsg::TransmissionStarted { speaker: ME, tx: TxId(1), metadata, .. })
                if metadata == &vec![1]
        ));
        assert_eq!(first.len(), 2, "start and one frame: {first:?}");
        assert!(matches!(&first[1], Looped::Voice(v) if v.tx == TxId(1) && v.speaker == ME));

        let next = step(&mut t, &mut l);
        assert!(matches!(next.as_slice(), [Looped::Voice(v)] if v.tx == TxId(1)));

        t.unkey(TxId(1));
        let last = step(&mut t, &mut l);
        assert!(matches!(
            last.last(),
            Some(Looped::Message(ServerMsg::TransmissionEnded {
                speaker: ME,
                tx: TxId(1)
            }))
        ));
        assert!(step(&mut t, &mut l).is_empty());
    }

    #[test]
    fn nothing_without_loopback() {
        let (mut t, mut l) = (tx(), Loopback::default());
        t.key(TxId(1), radio());
        assert!(step(&mut t, &mut l).is_empty());
        t.unkey(TxId(1));
        assert!(step(&mut t, &mut l).is_empty());
    }

    #[test]
    fn re_announced_without_loopback_ends_it() {
        let (mut t, mut l) = (tx(), Loopback::default());
        t.set_loopback(TxId(1), true);
        t.key(TxId(1), radio());
        step(&mut t, &mut l);
        t.set_loopback(TxId(1), false);
        let mut other = radio();
        other.metadata = vec![2];
        t.key(TxId(1), other);
        let out = step(&mut t, &mut l);
        assert!(matches!(
            out.as_slice(),
            [Looped::Message(ServerMsg::TransmissionEnded {
                tx: TxId(1),
                ..
            })]
        ));
    }
}
