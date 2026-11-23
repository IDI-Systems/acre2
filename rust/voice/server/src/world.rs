//! The server's game-agnostic model of who is where, what they listen to, and who hears whom.
//!
//! [`World`] is synchronous and does no I/O: every mutation returns the control messages to send
//! and records which speakers' routes changed. The network layer applies those.

use std::collections::{BTreeMap, BTreeSet, HashMap, HashSet};

use acre2_voice_proto::{
    ChannelKey, ChannelRule, ExternalId, ExtraPosition, MatchedTarget, PeerId, ServerMsg, Target,
    TxId, Vec3, WorldUpdate, distance_sq,
};

use crate::rules::{self, Access};

/// Routing limits.
#[derive(Debug, Clone)]
pub struct Limits {
    /// Upper bound for [`Target::Spatial`] ranges, in metres.
    pub max_spatial_range: f32,
    pub max_extra_positions: usize,
    pub max_targets: usize,
    pub max_subscriptions: usize,
    pub max_transmissions_per_peer: usize,
    pub max_metadata_len: usize,
}

impl Default for Limits {
    fn default() -> Self {
        Self {
            max_spatial_range: 300.0,
            max_extra_positions: 4,
            max_targets: 32,
            max_subscriptions: 256,
            max_transmissions_per_peer: 16,
            max_metadata_len: 1024,
        }
    }
}

/// A control message for one peer.
pub type Outgoing = (PeerId, ServerMsg);

/// Authority-owned state of a player. Exists independently of whether they're connected.
#[derive(Debug, Default, Clone)]
struct Player {
    position: Option<Vec3>,
    active: bool,
    rules: Vec<ChannelRule>,
    report_position: bool,
}

#[derive(Debug)]
struct Peer {
    external_id: ExternalId,
    subscriptions: HashSet<ChannelKey>,
    extra: Vec<ExtraPosition>,
    transmissions: BTreeMap<TxId, Transmission>,
}

#[derive(Debug)]
struct Transmission {
    targets: Vec<Target>,
    metadata: Vec<u8>,
    recipients: BTreeMap<PeerId, Vec<MatchedTarget>>,
}

#[derive(Debug, Default)]
pub struct World {
    limits: Limits,
    players: HashMap<ExternalId, Player>,
    peers: BTreeMap<PeerId, Peer>,
    global_rules: Vec<ChannelRule>,
    /// Speakers whose recipient sets changed since the last [`World::take_dirty_routes`].
    dirty_routes: BTreeSet<PeerId>,
}

fn finite(v: Vec3) -> bool {
    v.iter().all(|c| c.is_finite())
}

impl World {
    #[must_use]
    pub fn new(limits: Limits) -> Self {
        Self {
            limits,
            ..Self::default()
        }
    }

    #[must_use]
    pub fn peer_count(&self) -> usize {
        self.peers.len()
    }

    #[must_use]
    pub fn peer_by_external(&self, external_id: &str) -> Option<PeerId> {
        self.peers
            .iter()
            .find(|(_, p)| p.external_id == external_id)
            .map(|(id, _)| *id)
    }

    #[must_use]
    pub fn external_id(&self, peer: PeerId) -> Option<&str> {
        self.peers.get(&peer).map(|p| p.external_id.as_str())
    }

    // ---- peers -----------------------------------------------------------------------------

    pub fn add_peer(&mut self, peer: PeerId, external_id: ExternalId) {
        self.peers.insert(
            peer,
            Peer {
                external_id,
                subscriptions: HashSet::new(),
                extra: Vec::new(),
                transmissions: BTreeMap::new(),
            },
        );
        self.dirty_routes.insert(peer);
    }

    /// Removes a peer, ending its transmissions. Unknown peers are ignored.
    pub fn remove_peer(&mut self, peer: PeerId) -> Vec<Outgoing> {
        let Some(removed) = self.peers.remove(&peer) else {
            return Vec::new();
        };
        let mut out = Vec::new();
        for (tx, t) in removed.transmissions {
            for recipient in t.recipients.keys() {
                out.push((
                    *recipient,
                    ServerMsg::TransmissionEnded { speaker: peer, tx },
                ));
            }
        }
        // Drop it from everyone else's recipient lists.
        for (speaker, p) in &mut self.peers {
            for t in p.transmissions.values_mut() {
                if t.recipients.remove(&peer).is_some() {
                    self.dirty_routes.insert(*speaker);
                }
            }
        }
        self.dirty_routes.insert(peer);
        out
    }

    // ---- client requests -------------------------------------------------------------------

    /// Starts or replaces a transmission. Channel targets the speaker may not transmit on are
    /// dropped and reported in the error, but the rest of the transmission still starts.
    pub fn start_transmission(
        &mut self,
        speaker: PeerId,
        tx: TxId,
        targets: Vec<Target>,
        metadata: Vec<u8>,
    ) -> (Vec<Outgoing>, Option<String>) {
        let Some(peer) = self.peers.get(&speaker) else {
            return (Vec::new(), None);
        };
        if targets.len() > self.limits.max_targets {
            return (
                Vec::new(),
                Some(format!(
                    "too many targets (max {})",
                    self.limits.max_targets
                )),
            );
        }
        if metadata.len() > self.limits.max_metadata_len {
            return (
                Vec::new(),
                Some(format!(
                    "metadata too long (max {} bytes)",
                    self.limits.max_metadata_len
                )),
            );
        }
        if !peer.transmissions.contains_key(&tx)
            && peer.transmissions.len() >= self.limits.max_transmissions_per_peer
        {
            return (
                Vec::new(),
                Some(format!(
                    "too many transmissions (max {})",
                    self.limits.max_transmissions_per_peer
                )),
            );
        }

        let player = self.players.get(&peer.external_id);
        let player_rules = player.map_or(&[][..], |p| &p.rules);
        let mut denied = Vec::new();
        let targets: Vec<Target> = targets
            .into_iter()
            .filter(|t| match t {
                Target::Spatial { range } => range.is_finite() && *range > 0.0,
                Target::Channel(key) => {
                    let ok = rules::allowed(player_rules, &self.global_rules, key, Access::Tx);
                    if !ok {
                        denied.push(key.to_string());
                    }
                    ok
                }
            })
            .collect();
        let error = (!denied.is_empty())
            .then(|| format!("not allowed to transmit on: {}", denied.join(", ")));

        let recipients = self.resolve(speaker, &targets);
        let peer = self.peers.get_mut(&speaker).expect("checked above");
        let old = peer.transmissions.insert(
            tx,
            Transmission {
                targets,
                metadata,
                recipients: BTreeMap::new(),
            },
        );
        let mut out = Vec::new();
        if let Some(old) = old {
            for r in old
                .recipients
                .keys()
                .filter(|r| !recipients.contains_key(r))
            {
                out.push((*r, ServerMsg::TransmissionEnded { speaker, tx }));
            }
            if !old.recipients.keys().eq(recipients.keys()) {
                self.dirty_routes.insert(speaker);
            }
        }
        // Diff against nothing: metadata may have changed, so everyone who still hears the
        // transmission gets it announced afresh.
        out.extend(self.apply_recipients(speaker, tx, &BTreeMap::new(), recipients));
        (out, error)
    }

    pub fn stop_transmission(&mut self, speaker: PeerId, tx: TxId) -> Vec<Outgoing> {
        let Some(t) = self
            .peers
            .get_mut(&speaker)
            .and_then(|p| p.transmissions.remove(&tx))
        else {
            return Vec::new();
        };
        if !t.recipients.is_empty() {
            self.dirty_routes.insert(speaker);
        }
        t.recipients
            .into_keys()
            .map(|r| (r, ServerMsg::TransmissionEnded { speaker, tx }))
            .collect()
    }

    pub fn set_subscriptions(
        &mut self,
        peer: PeerId,
        channels: Vec<ChannelKey>,
    ) -> (Vec<Outgoing>, Option<String>) {
        let Some(p) = self.peers.get_mut(&peer) else {
            return (Vec::new(), None);
        };
        if channels.len() > self.limits.max_subscriptions {
            return (
                Vec::new(),
                Some(format!(
                    "too many subscriptions (max {})",
                    self.limits.max_subscriptions
                )),
            );
        }
        p.subscriptions = channels.into_iter().collect();
        (self.reresolve_all(), None)
    }

    pub fn set_extra_positions(
        &mut self,
        peer: PeerId,
        positions: Vec<ExtraPosition>,
    ) -> Result<(), String> {
        let Some(p) = self.peers.get_mut(&peer) else {
            return Ok(());
        };
        let allowed = self
            .players
            .get(&p.external_id)
            .is_some_and(|pl| pl.report_position);
        if !allowed && !positions.is_empty() {
            return Err("not allowed to report positions".into());
        }
        if positions.len() > self.limits.max_extra_positions {
            return Err(format!(
                "too many positions (max {})",
                self.limits.max_extra_positions
            ));
        }
        if !positions.iter().all(|e| finite(e.position)) {
            return Err("position is not finite".into());
        }
        p.extra = positions;
        Ok(())
    }

    // ---- authority -------------------------------------------------------------------------

    pub fn apply_world(&mut self, updates: Vec<WorldUpdate>) {
        for u in updates {
            let player = self.players.entry(u.external_id).or_default();
            if finite(u.position) {
                player.position = Some(u.position);
            }
            player.active = u.active;
        }
    }

    /// Forgets a player. Returns their peer, if connected, for the caller to disconnect.
    pub fn remove_player(&mut self, external_id: &str) -> Option<PeerId> {
        self.players.remove(external_id);
        self.peer_by_external(external_id)
    }

    pub fn set_rules(
        &mut self,
        external_id: Option<ExternalId>,
        rules: Vec<ChannelRule>,
    ) -> Vec<Outgoing> {
        match external_id {
            Some(id) => self.players.entry(id).or_default().rules = rules,
            None => self.global_rules = rules,
        }
        self.reresolve_all()
    }

    pub fn set_report_position(&mut self, external_id: ExternalId, allowed: bool) {
        if !allowed && let Some(peer) = self.peer_by_external(&external_id) {
            self.peers
                .get_mut(&peer)
                .expect("found above")
                .extra
                .clear();
        }
        self.players.entry(external_id).or_default().report_position = allowed;
    }

    // ---- routing ---------------------------------------------------------------------------

    /// Re-resolves every transmission against the current state. Called periodically (people
    /// move) and after subscription or rule changes.
    pub fn reresolve_all(&mut self) -> Vec<Outgoing> {
        let mut work = Vec::new();
        for (speaker, p) in &self.peers {
            for (tx, t) in &p.transmissions {
                work.push((*speaker, *tx, self.resolve(*speaker, &t.targets)));
            }
        }
        let mut out = Vec::new();
        for (speaker, tx, recipients) in work {
            let old = std::mem::take(
                &mut self
                    .peers
                    .get_mut(&speaker)
                    .and_then(|p| p.transmissions.get_mut(&tx))
                    .expect("collected above")
                    .recipients,
            );
            out.extend(self.apply_recipients(speaker, tx, &old, recipients));
        }
        out
    }

    /// Stores new recipients for a transmission and returns the start/update/end messages.
    fn apply_recipients(
        &mut self,
        speaker: PeerId,
        tx: TxId,
        old: &BTreeMap<PeerId, Vec<MatchedTarget>>,
        new: BTreeMap<PeerId, Vec<MatchedTarget>>,
    ) -> Vec<Outgoing> {
        let peer = self.peers.get_mut(&speaker).expect("speaker exists");
        let t = peer
            .transmissions
            .get_mut(&tx)
            .expect("transmission exists");
        let mut out = Vec::new();
        for r in old.keys().filter(|r| !new.contains_key(r)) {
            out.push((*r, ServerMsg::TransmissionEnded { speaker, tx }));
        }
        for (r, matched) in &new {
            let changed = old.get(r).is_none_or(|prev| !same_targets(prev, matched));
            if changed {
                out.push((
                    *r,
                    ServerMsg::TransmissionStarted {
                        speaker,
                        speaker_external_id: peer.external_id.clone(),
                        tx,
                        matched: matched.clone(),
                        metadata: t.metadata.clone(),
                    },
                ));
            }
        }
        if !old.keys().eq(new.keys()) {
            self.dirty_routes.insert(speaker);
        }
        t.recipients = new;
        out
    }

    fn emitter_position(&self, peer: &Peer) -> Option<Vec3> {
        peer.extra
            .iter()
            .find(|e| e.role.is_emitter())
            .map(|e| e.position)
            .or_else(|| {
                self.players
                    .get(&peer.external_id)
                    .filter(|p| p.active)
                    .and_then(|p| p.position)
            })
    }

    fn listener_positions<'a>(&'a self, peer: &'a Peer) -> impl Iterator<Item = Vec3> + 'a {
        self.players
            .get(&peer.external_id)
            .filter(|p| p.active)
            .and_then(|p| p.position)
            .into_iter()
            .chain(
                peer.extra
                    .iter()
                    .filter(|e| e.role.is_listener())
                    .map(|e| e.position),
            )
    }

    fn resolve(&self, speaker: PeerId, targets: &[Target]) -> BTreeMap<PeerId, Vec<MatchedTarget>> {
        let mut out: BTreeMap<PeerId, Vec<MatchedTarget>> = BTreeMap::new();
        let Some(speaker_peer) = self.peers.get(&speaker) else {
            return out;
        };
        let speaker_rules = self
            .players
            .get(&speaker_peer.external_id)
            .map_or(&[][..], |p| &p.rules);

        // Spatial: one pass with the largest requested range.
        let range = targets
            .iter()
            .filter_map(|t| match t {
                Target::Spatial { range } => Some(range.min(self.limits.max_spatial_range)),
                Target::Channel(_) => None,
            })
            .fold(None, |acc: Option<f32>, r| {
                Some(acc.map_or(r, |a| a.max(r)))
            });
        if let (Some(range), Some(emitter)) = (range, self.emitter_position(speaker_peer)) {
            let range_sq = range * range;
            for (id, p) in &self.peers {
                if *id == speaker {
                    continue;
                }
                let nearest = self
                    .listener_positions(p)
                    .map(|l| distance_sq(emitter, l))
                    .fold(f32::INFINITY, f32::min);
                if nearest <= range_sq {
                    out.entry(*id).or_default().push(MatchedTarget::Spatial {
                        distance: nearest.sqrt(),
                    });
                }
            }
        }

        for t in targets {
            let Target::Channel(key) = t else { continue };
            // Rules can change while a transmission is running.
            if !rules::allowed(speaker_rules, &self.global_rules, key, Access::Tx) {
                continue;
            }
            for (id, p) in &self.peers {
                if *id == speaker || !p.subscriptions.contains(key) {
                    continue;
                }
                let rules = self
                    .players
                    .get(&p.external_id)
                    .map_or(&[][..], |pl| &pl.rules);
                if !rules::allowed(rules, &self.global_rules, key, Access::Rx) {
                    continue;
                }
                let matched = out.entry(*id).or_default();
                let m = MatchedTarget::Channel(key.clone());
                if !matched.contains(&m) {
                    matched.push(m);
                }
            }
        }
        out
    }

    /// Speakers whose recipient sets changed since the last call.
    pub fn take_dirty_routes(&mut self) -> BTreeSet<PeerId> {
        std::mem::take(&mut self.dirty_routes)
    }

    /// Current recipients of each of a speaker's transmissions.
    #[must_use]
    pub fn routes(&self, speaker: PeerId) -> BTreeMap<TxId, Vec<PeerId>> {
        self.peers.get(&speaker).map_or_else(BTreeMap::new, |p| {
            p.transmissions
                .iter()
                .map(|(tx, t)| (*tx, t.recipients.keys().copied().collect()))
                .collect()
        })
    }
}

/// Whether two matched-target lists are the same, ignoring small spatial distance changes so
/// that people walking around don't cause a message every tick.
fn same_targets(a: &[MatchedTarget], b: &[MatchedTarget]) -> bool {
    a.len() == b.len()
        && a.iter().zip(b).all(|(x, y)| match (x, y) {
            (MatchedTarget::Spatial { .. }, MatchedTarget::Spatial { .. }) => true,
            _ => x == y,
        })
}

#[cfg(test)]
mod tests {
    use acre2_voice_proto::PositionRole;

    use super::*;

    const A: PeerId = PeerId(1);
    const B: PeerId = PeerId(2);
    const C: PeerId = PeerId(3);

    fn key(s: &str) -> ChannelKey {
        ChannelKey::new(s).unwrap()
    }

    fn world() -> World {
        let mut w = World::new(Limits::default());
        for (peer, ext) in [(A, "a"), (B, "b"), (C, "c")] {
            w.add_peer(peer, ext.into());
        }
        w.apply_world(vec![
            upd("a", [0.0, 0.0, 0.0]),
            upd("b", [10.0, 0.0, 0.0]),
            upd("c", [1000.0, 0.0, 0.0]),
        ]);
        w.take_dirty_routes();
        w
    }

    fn upd(ext: &str, position: Vec3) -> WorldUpdate {
        WorldUpdate {
            external_id: ext.into(),
            position,
            active: true,
        }
    }

    fn started_for(out: &[Outgoing]) -> Vec<PeerId> {
        out.iter()
            .filter(|(_, m)| matches!(m, ServerMsg::TransmissionStarted { .. }))
            .map(|(p, _)| *p)
            .collect()
    }

    fn ended_for(out: &[Outgoing]) -> Vec<PeerId> {
        out.iter()
            .filter(|(_, m)| matches!(m, ServerMsg::TransmissionEnded { .. }))
            .map(|(p, _)| *p)
            .collect()
    }

    #[test]
    fn spatial_reaches_only_nearby() {
        let mut w = world();
        let (out, err) =
            w.start_transmission(A, TxId(0), vec![Target::Spatial { range: 50.0 }], vec![]);
        assert!(err.is_none());
        assert_eq!(started_for(&out), vec![B]);
        assert_eq!(w.routes(A)[&TxId(0)], vec![B]);
        assert!(w.take_dirty_routes().contains(&A));
    }

    #[test]
    fn spatial_range_is_clamped() {
        let mut w = world();
        let (out, _) =
            w.start_transmission(A, TxId(0), vec![Target::Spatial { range: 5000.0 }], vec![]);
        assert_eq!(started_for(&out), vec![B]);
    }

    #[test]
    fn channel_ignores_distance() {
        let mut w = world();
        w.set_subscriptions(C, vec![key("radio:1")]);
        let (out, _) =
            w.start_transmission(A, TxId(0), vec![Target::Channel(key("radio:1"))], vec![]);
        assert_eq!(started_for(&out), vec![C]);
    }

    #[test]
    fn multiple_matches_merge_into_one_start() {
        let mut w = world();
        w.set_subscriptions(B, vec![key("radio:1")]);
        let (out, _) = w.start_transmission(
            A,
            TxId(0),
            vec![
                Target::Spatial { range: 50.0 },
                Target::Channel(key("radio:1")),
            ],
            vec![7],
        );
        assert_eq!(out.len(), 1);
        let ServerMsg::TransmissionStarted {
            matched, metadata, ..
        } = &out[0].1
        else {
            panic!()
        };
        assert_eq!(matched.len(), 2);
        assert_eq!(metadata, &vec![7]);
    }

    #[test]
    fn moving_in_and_out_of_range() {
        let mut w = world();
        w.start_transmission(A, TxId(0), vec![Target::Spatial { range: 50.0 }], vec![]);
        w.take_dirty_routes();

        // Small move: no messages.
        w.apply_world(vec![upd("b", [12.0, 0.0, 0.0])]);
        assert_eq!(
            w.reresolve_all(),
            [] as [(acre2_voice_proto::PeerId, acre2_voice_proto::ServerMsg); 0]
        );
        assert!(w.take_dirty_routes().is_empty());

        // C walks in, B walks out.
        w.apply_world(vec![upd("b", [100.0, 0.0, 0.0]), upd("c", [5.0, 0.0, 0.0])]);
        let out = w.reresolve_all();
        assert_eq!(started_for(&out), vec![C]);
        assert_eq!(ended_for(&out), vec![B]);
        assert!(w.take_dirty_routes().contains(&A));
    }

    #[test]
    fn subscribing_mid_transmission() {
        let mut w = world();
        w.start_transmission(A, TxId(0), vec![Target::Channel(key("radio:1"))], vec![]);
        let (out, _) = w.set_subscriptions(C, vec![key("radio:1")]);
        assert_eq!(started_for(&out), vec![C]);
        let (out, _) = w.set_subscriptions(C, vec![]);
        assert_eq!(ended_for(&out), vec![C]);
    }

    #[test]
    fn stop_and_remove() {
        let mut w = world();
        w.start_transmission(A, TxId(0), vec![Target::Spatial { range: 50.0 }], vec![]);
        assert_eq!(ended_for(&w.stop_transmission(A, TxId(0))), vec![B]);
        assert_eq!(
            w.stop_transmission(A, TxId(0)),
            [] as [(acre2_voice_proto::PeerId, acre2_voice_proto::ServerMsg); 0]
        );

        w.start_transmission(A, TxId(1), vec![Target::Spatial { range: 50.0 }], vec![]);
        w.take_dirty_routes();
        assert_eq!(ended_for(&w.remove_peer(A)), vec![B]);
        assert!(w.routes(A).is_empty());

        // Removing a recipient updates the speaker's routes.
        w.start_transmission(B, TxId(0), vec![Target::Spatial { range: 2000.0 }], vec![]);
        w.add_peer(A, "a".into());
        w.reresolve_all();
        w.take_dirty_routes();
        w.remove_peer(A);
        assert!(w.take_dirty_routes().contains(&B));
    }

    #[test]
    fn inactive_players_neither_emit_nor_hear() {
        let mut w = world();
        w.apply_world(vec![WorldUpdate {
            active: false,
            ..upd("b", [10.0, 0.0, 0.0])
        }]);
        let (out, _) =
            w.start_transmission(A, TxId(0), vec![Target::Spatial { range: 50.0 }], vec![]);
        assert_eq!(
            out,
            [] as [(acre2_voice_proto::PeerId, acre2_voice_proto::ServerMsg); 0]
        );
        let (out, _) =
            w.start_transmission(B, TxId(0), vec![Target::Spatial { range: 50.0 }], vec![]);
        assert_eq!(
            out,
            [] as [(acre2_voice_proto::PeerId, acre2_voice_proto::ServerMsg); 0]
        );
    }

    #[test]
    fn extra_positions_need_permission() {
        let mut w = world();
        let cam = vec![ExtraPosition {
            position: [995.0, 0.0, 0.0],
            role: PositionRole::Both,
        }];
        assert!(w.set_extra_positions(A, cam.clone()).is_err());
        w.set_report_position("a".into(), true);
        assert!(w.set_extra_positions(A, cam).is_ok());

        // Zeus camera near C: A's speech now comes from the camera.
        let (out, _) =
            w.start_transmission(A, TxId(0), vec![Target::Spatial { range: 50.0 }], vec![]);
        assert_eq!(started_for(&out), vec![C]);

        // Revoking clears the camera; speech comes from the body again.
        w.set_report_position("a".into(), false);
        let out = w.reresolve_all();
        assert_eq!(started_for(&out), vec![B]);
        assert_eq!(ended_for(&out), vec![C]);
    }

    #[test]
    fn listener_extra_uses_nearest_position() {
        let mut w = world();
        w.set_report_position("c".into(), true);
        w.set_extra_positions(
            C,
            vec![ExtraPosition {
                position: [3.0, 0.0, 0.0],
                role: PositionRole::Listener,
            }],
        )
        .unwrap();
        let (out, _) =
            w.start_transmission(A, TxId(0), vec![Target::Spatial { range: 50.0 }], vec![]);
        let mut started = started_for(&out);
        started.sort();
        assert_eq!(started, vec![B, C]);
        let ServerMsg::TransmissionStarted { matched, .. } =
            &out.iter().find(|(p, _)| *p == C).unwrap().1
        else {
            panic!()
        };
        assert_eq!(matched, &vec![MatchedTarget::Spatial { distance: 3.0 }]);
    }

    #[test]
    fn rules_gate_tx_and_rx() {
        let mut w = world();
        w.set_rules(
            None,
            vec![ChannelRule {
                prefix: "god:".into(),
                allow_tx: false,
                allow_rx: false,
            }],
        );
        w.set_subscriptions(B, vec![key("god:1")]);
        let (out, err) =
            w.start_transmission(A, TxId(0), vec![Target::Channel(key("god:1"))], vec![]);
        assert_eq!(
            out,
            [] as [(acre2_voice_proto::PeerId, acre2_voice_proto::ServerMsg); 0]
        );
        assert!(err.unwrap().contains("god:1"));

        // Allow A to transmit; B still can't receive until it's allowed too.
        w.set_rules(
            Some("a".into()),
            vec![ChannelRule {
                prefix: "god:".into(),
                allow_tx: true,
                allow_rx: true,
            }],
        );
        let (out, err) =
            w.start_transmission(A, TxId(0), vec![Target::Channel(key("god:1"))], vec![]);
        assert!(err.is_none());
        assert_eq!(
            out,
            [] as [(acre2_voice_proto::PeerId, acre2_voice_proto::ServerMsg); 0]
        );
        let out = w.set_rules(
            Some("b".into()),
            vec![ChannelRule {
                prefix: "god:".into(),
                allow_tx: false,
                allow_rx: true,
            }],
        );
        assert_eq!(started_for(&out), vec![B]);
    }

    #[test]
    fn restarting_a_transmission_reannounces() {
        let mut w = world();
        w.set_subscriptions(C, vec![key("radio:1")]);
        w.start_transmission(A, TxId(0), vec![Target::Spatial { range: 50.0 }], vec![1]);
        let (out, _) =
            w.start_transmission(A, TxId(0), vec![Target::Channel(key("radio:1"))], vec![2]);
        assert_eq!(ended_for(&out), vec![B]);
        assert_eq!(started_for(&out), vec![C]);
    }

    #[test]
    fn limits_are_enforced() {
        let mut w = World::new(Limits {
            max_transmissions_per_peer: 1,
            ..Limits::default()
        });
        w.add_peer(A, "a".into());
        assert!(w.start_transmission(A, TxId(0), vec![], vec![]).1.is_none());
        assert!(
            w.start_transmission(A, TxId(0), vec![], vec![]).1.is_none(),
            "replacing is fine"
        );
        assert!(w.start_transmission(A, TxId(1), vec![], vec![]).1.is_some());
        assert!(
            w.start_transmission(A, TxId(0), vec![], vec![0; 2000])
                .1
                .is_some()
        );
    }
}
