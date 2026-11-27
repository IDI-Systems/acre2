//! Player-side commands: connecting, transmitting, and the parameters SQF feeds the renderer.
//!
//! Settings made while disconnected are kept and applied on (re)connect.

use std::{
    collections::{BTreeMap, HashMap},
    sync::{Arc, LazyLock, Mutex, MutexGuard},
};

use acre2_dsp::positional::{CurveModel, Listener, from_arma};
use acre2_voice_client::{
    Client, ConnectionStats,
    audio::{
        ActivationConfig, ActivationMode, MicMonitor, NoiseConfig, Outgoing, SessionConfig,
        SessionEvent, VoiceSession, list_devices,
    },
    parse_fingerprint,
};
use acre2_voice_proto::{
    ChannelKey, ExtraPosition, PeerId, PositionRole, ServerMsg, Target, Token, TxId,
};
use arma_rs::Group;

use crate::{
    callback::emit,
    meta::Meta,
    meta::speaking_type,
    render::{AcreRenderer, DirectKind, DirectParams, RadioOut, RenderState, SharedState},
    runtime, sounds,
    speakers::{SpeakingEvent, Tracker},
};

#[derive(Debug, Default)]
struct Wanted {
    activation: ActivationConfig,
    noise: NoiseConfig,
    input: Option<String>,
    output: Option<String>,
    direct: Option<(Outgoing, Meta)>,
    keyed: BTreeMap<TxId, (Outgoing, Meta)>,
    direct_ptt: bool,
    muted: bool,
    /// Hear our own radio transmissions on our other radios (`tx:loopback`).
    loopback: bool,
    subscriptions: Vec<ChannelKey>,
    extra: Vec<ExtraPosition>,
}

struct State {
    render: SharedState,
    tracker: Tracker,
    session: Option<Arc<VoiceSession>>,
    connecting: bool,
    /// Bumped on every connect/disconnect, so stale tasks and event threads stand down.
    generation: u64,
    wanted: Wanted,
    keys: HashMap<String, TxId>,
    /// What each of our transmissions was last announced as, for local start/stop events.
    tx_meta: HashMap<TxId, Meta>,
    /// Where we're connected (or last tried), and why the last attempt failed.
    address: String,
    last_error: String,
    /// Microphone meter for when there's no session (mic test before joining).
    monitor: Option<MicMonitor>,
    /// Previous `voice:stats` sample, for rates.
    last_stats: Option<(std::time::Instant, ConnectionStats)>,
}

static STATE: LazyLock<Mutex<State>> = LazyLock::new(|| {
    Mutex::new(State {
        render: Arc::default(),
        tracker: Tracker::default(),
        session: None,
        connecting: false,
        generation: 0,
        wanted: Wanted {
            noise: NoiseConfig::ON,
            ..Wanted::default()
        },
        keys: HashMap::new(),
        tx_meta: HashMap::new(),
        address: String::new(),
        last_error: String::new(),
        monitor: None,
        last_stats: None,
    })
});

fn state() -> MutexGuard<'static, State> {
    STATE.lock().expect("client state")
}

impl State {
    fn render(&self) -> MutexGuard<'_, RenderState> {
        self.render.lock().expect("render state")
    }

    /// Pushes everything wanted to the live session.
    fn apply(&self) {
        let Some(s) = &self.session else { return };
        {
            let mut t = s.transmitter();
            t.set_exclusive(true);
            t.set_activation(self.wanted.activation);
            t.set_noise(self.wanted.noise);
            t.set_direct_ptt(self.wanted.direct_ptt);
            t.set_muted(self.wanted.muted);
            t.set_direct(self.wanted.direct.as_ref().map(|(o, _)| o.clone()));
        }
        self.apply_keyed();
        let _ = s
            .client()
            .set_subscriptions(self.wanted.subscriptions.clone());
        let _ = s.client().set_extra_positions(self.wanted.extra.clone());
    }

    fn apply_keyed(&self) {
        let Some(s) = &self.session else { return };
        let mut t = s.transmitter();
        for tx in self.keys.values() {
            match self.wanted.keyed.get(tx) {
                Some((o, meta)) => {
                    // Only radio is heard elsewhere by our own radios; SQF decides which (if
                    // any) and how, with `speaker:radio` for our own peer id.
                    let looped = self.wanted.loopback && meta.speaking_type == speaking_type::RADIO;
                    t.set_loopback(*tx, looped);
                    t.key(*tx, o.clone());
                }
                None => t.unkey(*tx),
            }
        }
    }

    fn me(&self) -> Option<PeerId> {
        self.session.as_ref().map(|s| s.client().peer_id())
    }

    fn take_session(&mut self) -> Option<Arc<VoiceSession>> {
        self.generation += 1;
        self.connecting = false;
        let events = {
            let mut st = self.render.lock().expect("render state");
            self.tracker.clear(&mut st)
        };
        emit_speaking(events, self.me());
        self.session.take()
    }
}

/// Tells SQF about remote speakers. Our own looped-back radio transmissions (`tx:loopback`) are
/// tracked like a remote speaker's, so they render, but SQF already knows we're speaking.
fn emit_speaking(events: Vec<SpeakingEvent>, me: Option<PeerId>) {
    for e in events {
        let peer = match &e {
            SpeakingEvent::Start { peer, .. } | SpeakingEvent::Stop { peer, .. } => *peer,
        };
        if Some(peer) == me {
            continue;
        }
        match e {
            SpeakingEvent::Start { peer, meta } => emit(
                "remote_start",
                (
                    peer.0,
                    meta.language_id,
                    meta.net_id,
                    i32::from(meta.speaking_type),
                    meta.radio_id,
                ),
            ),
            SpeakingEvent::Stop { peer, meta } => emit("remote_stop", (peer.0, meta.net_id)),
        }
    }
}

fn targets(range: f32, channels: Vec<String>) -> Result<Vec<Target>, String> {
    let mut t = Vec::new();
    if range > 0.0 {
        t.push(Target::Spatial { range });
    }
    for c in channels {
        t.push(Target::Channel(
            ChannelKey::new(c).map_err(|e| e.to_string())?,
        ));
    }
    Ok(t)
}

// ---- voice ------------------------------------------------------------------------------------

/// `["voice:connect", [address, tokenHex, fingerprintHex]]` → `"ok"`, then the `connected`
/// (`[peerId]`) or `connect_failed` (`[reason]`) callback.
fn connect(address: String, token: String, fingerprint: String) -> Result<&'static str, String> {
    let token = Token::from_hex(&token).ok_or("invalid token")?;
    let fingerprint = parse_fingerprint(&fingerprint).ok_or("invalid fingerprint")?;
    let (old, generation, render, config) = {
        let mut st = state();
        let old = st.take_session();
        st.connecting = true;
        st.address.clone_from(&address);
        let config = SessionConfig {
            activation: st.wanted.activation,
            input_device: st.wanted.input.clone(),
            output_device: st.wanted.output.clone(),
            ..SessionConfig::default()
        };
        (old, st.generation, st.render.clone(), config)
    };
    drop(old);
    runtime::get().spawn(async move {
        let result = async {
            let (client, events) = Client::connect(&address, fingerprint, token)
                .await
                .map_err(|e| e.to_string())?;
            let peer = client.peer_id();
            let (session, session_events) =
                VoiceSession::start(client, events, config, Box::new(AcreRenderer::new(render)))
                    .map_err(|e| e.to_string())?;
            Ok::<_, String>((peer, session, session_events))
        }
        .await;
        let mut st = state();
        if st.generation != generation {
            return; // superseded
        }
        st.connecting = false;
        match result {
            Ok((peer, session, session_events)) => {
                tracing::info!(%peer, %address, "connected to voice server");
                st.session = Some(Arc::new(session));
                st.last_error.clear();
                st.last_stats = None;
                st.apply();
                drop(st);
                std::thread::Builder::new()
                    .name("acre2-events".into())
                    .spawn(move || pump_events(&session_events, generation))
                    .expect("spawning event thread");
                emit("connected", vec![peer.0]);
            }
            Err(e) => {
                tracing::warn!(error = %e, %address, "could not connect to voice server");
                st.last_error.clone_from(&e);
                drop(st);
                emit("connect_failed", vec![e]);
            }
        }
    });
    Ok("ok")
}

fn pump_events(events: &std::sync::mpsc::Receiver<SessionEvent>, generation: u64) {
    for ev in events {
        let mut st = state();
        if st.generation != generation {
            return;
        }
        match ev {
            SessionEvent::Server(ServerMsg::TransmissionStarted {
                speaker,
                tx,
                metadata,
                ..
            }) => {
                let me = st.me();
                let events = {
                    let State {
                        render, tracker, ..
                    } = &mut *st;
                    tracker.started(
                        &mut render.lock().expect("render state"),
                        speaker,
                        tx,
                        &metadata,
                    )
                };
                drop(st);
                emit_speaking(events, me);
            }
            SessionEvent::Server(ServerMsg::TransmissionEnded { speaker, tx }) => {
                let me = st.me();
                let events = {
                    let State {
                        render, tracker, ..
                    } = &mut *st;
                    tracker.ended(&mut render.lock().expect("render state"), speaker, tx)
                };
                drop(st);
                emit_speaking(events, me);
            }
            SessionEvent::Server(ServerMsg::Error { message }) => {
                drop(st);
                tracing::warn!(%message, "voice server refused a request");
                emit("server_error", vec![message]);
            }
            SessionEvent::Server(_) => {}
            SessionEvent::Transmitting { tx, active } => {
                let peer = st.session.as_ref().map_or(0, |s| s.client().peer_id().0);
                let meta = st.tx_meta.get(&tx).cloned();
                drop(st);
                if let Some(m) = meta {
                    let data = (peer, m.language_id, i32::from(m.speaking_type), m.radio_id);
                    emit(if active { "local_start" } else { "local_stop" }, data);
                }
            }
            SessionEvent::Device(d) => {
                drop(st);
                emit("device", vec![format!("{d:?}")]);
            }
            SessionEvent::Closed { reason } => {
                let old = st.take_session();
                drop(st);
                drop(old);
                tracing::info!(%reason, "disconnected from voice server");
                emit("disconnected", vec![reason]);
                return;
            }
        }
    }
}

/// `["voice:disconnect", []]`
fn disconnect() {
    let old = state().take_session();
    drop(old);
}

/// `["voice:status", []]` → `["connected" | "connecting" | "disconnected", peerId]`
fn status() -> (String, u32) {
    let st = state();
    match &st.session {
        Some(s) => ("connected".into(), s.client().peer_id().0),
        None if st.connecting => ("connecting".into(), 0),
        None => ("disconnected".into(), 0),
    }
}

// ---- transmitting ---------------------------------------------------------------------------

/// `["tx:direct", [range, [channels], netId, languageId, curveScale]]`: where direct speech
/// goes (range ≤ 0 for no spatial target, e.g. spectators on the `spectator` channel).
fn tx_direct(
    range: f32,
    channels: Vec<String>,
    net_id: String,
    language_id: i32,
    curve_scale: f32,
) -> Result<(), String> {
    let meta = Meta {
        speaking_type: crate::meta::speaking_type::DIRECT,
        radio_id: String::new(),
        net_id,
        language_id,
        curve_scale,
    };
    let outgoing = Outgoing {
        targets: targets(range, channels)?,
        metadata: meta.encode(),
    };
    let mut st = state();
    st.tx_meta.insert(TxId(0), meta.clone());
    st.wanted.direct = Some((outgoing.clone(), meta));
    if let Some(s) = &st.session {
        s.transmitter().set_direct(Some(outgoing));
    }
    Ok(())
}

/// `["tx:start", [key, speakingType, radioId, range, [channels], netId, languageId, curveScale]]`:
/// presses a PTT (radio, intercom, zeus, god). `key` names it for `tx:stop`, e.g. the radio id.
fn tx_start(
    key: String,
    speaking_type: u8,
    radio_id: String,
    range: f32,
    channels: Vec<String>,
    net_id: String,
    language_id: i32,
    curve_scale: f32,
) -> Result<(), String> {
    let meta = Meta {
        speaking_type,
        radio_id,
        net_id,
        language_id,
        curve_scale,
    };
    let outgoing = Outgoing {
        targets: targets(range, channels)?,
        metadata: meta.encode(),
    };
    let mut st = state();
    let next = TxId(st.keys.len() as u16 + 1);
    let tx = *st.keys.entry(key).or_insert(next);
    st.tx_meta.insert(tx, meta.clone());
    st.wanted.keyed.insert(tx, (outgoing, meta));
    st.apply_keyed();
    Ok(())
}

/// `["tx:stop", [key]]`
fn tx_stop(key: String) {
    let mut st = state();
    if let Some(tx) = st.keys.get(&key).copied() {
        st.wanted.keyed.remove(&tx);
        st.apply_keyed();
    }
}

/// `["tx:loopback", [enabled]]`: hear our own radio transmissions on our other radios. Each radio
/// transmission is then also played back locally as a stream from our own peer id, rendered by
/// `speaker:radio` for that id like a remote speaker (no `remote_start`/`remote_stop`). Applies
/// from the next transmission.
fn tx_loopback(enabled: bool) {
    let mut st = state();
    st.wanted.loopback = enabled;
    st.apply_keyed();
}

/// `["tx:stop_all", []]`
fn tx_stop_all() {
    let mut st = state();
    st.wanted.keyed.clear();
    st.apply_keyed();
}

/// `["rx:channels", [[channels]]]`: the channels we listen to (radio frequencies etc.).
fn rx_channels(channels: Vec<String>) -> Result<(), String> {
    let keys = channels
        .into_iter()
        .map(|c| ChannelKey::new(c).map_err(|e| e.to_string()))
        .collect::<Result<Vec<_>, _>>()?;
    let mut st = state();
    if keys != st.wanted.subscriptions {
        st.wanted.subscriptions.clone_from(&keys);
        if let Some(s) = &st.session {
            let _ = s.client().set_subscriptions(keys);
        }
    }
    Ok(())
}

// ---- voice activation -------------------------------------------------------------------------

/// `["vox:settings", ["vad" | "ptt", openDb, closeDb]]`: voice activation opens at `openDb` and
/// closes once below `closeDb` (after a short hangover).
fn vox_settings(mode: String, open_db: f32, close_db: f32) -> Result<(), String> {
    let mode = match mode.as_str() {
        "vad" => ActivationMode::Voice,
        "ptt" => ActivationMode::PushToTalk,
        other => return Err(format!("unknown mode {other}")),
    };
    let mut st = state();
    st.wanted.activation = ActivationConfig {
        mode,
        open_db,
        close_db: close_db.min(open_db),
        ..st.wanted.activation
    };
    if let Some(s) = &st.session {
        s.transmitter().set_activation(st.wanted.activation);
    }
    Ok(())
}

/// `["vox:ptt", [pressed]]`: the direct-speech PTT key.
fn vox_ptt(pressed: bool) {
    let mut st = state();
    st.wanted.direct_ptt = pressed;
    if let Some(s) = &st.session {
        s.transmitter().set_direct_ptt(pressed);
    }
}

/// `["vox:noise", [suppress, speechDetection]]`: the microphone filter. `suppress` removes
/// background noise from what's sent; `speechDetection` makes voice activation open only on
/// speech, not on any loud enough sound (keyboard clacks). Both on by default.
fn vox_noise(suppress: bool, speech_detection: bool) {
    let noise = NoiseConfig {
        suppress,
        speech_gate: speech_detection,
    };
    let mut st = state();
    if st.wanted.noise == noise {
        return;
    }
    st.wanted.noise = noise;
    if let Some(s) = &st.session {
        s.transmitter().set_noise(noise);
    }
    // A running mic test measures with the new filter.
    if st.monitor.is_some() {
        let input = st.wanted.input.clone();
        let old = st
            .monitor
            .replace(MicMonitor::start(input, Arc::new(|_| {}), noise));
        drop(st);
        drop(old);
    }
}

/// `["vox:mute", [muted]]`: mutes our microphone (`localMute`).
fn vox_mute(muted: bool) {
    let mut st = state();
    st.wanted.muted = muted;
    if let Some(s) = &st.session {
        s.transmitter().set_muted(muted);
    }
}

// ---- self -----------------------------------------------------------------------------------

/// `["self:update", [listenerPosASL, listenerDir]]` (`updateSelf`).
fn self_update(position: [f32; 3], direction: [f32; 3]) {
    let st = state();
    st.render().listener = Listener {
        position: from_arma(position),
        front: from_arma(direction),
    };
}

/// `["self:positions", [[[posASL, "emitter" | "listener" | "both"], …]]]`: Zeus or spectator
/// camera positions (only accepted while the server allows it). `[]` clears them.
fn self_positions(positions: Vec<([f32; 3], String)>) -> Result<(), String> {
    let extra = positions
        .into_iter()
        .map(|(position, role)| {
            let role = match role.as_str() {
                "emitter" => PositionRole::Emitter,
                "listener" => PositionRole::Listener,
                "both" => PositionRole::Both,
                other => return Err(format!("unknown role {other}")),
            };
            Ok(ExtraPosition { position, role })
        })
        .collect::<Result<Vec<_>, String>>()?;
    let mut st = state();
    st.wanted.extra.clone_from(&extra);
    if let Some(s) = &st.session {
        let _ = s.client().set_extra_positions(extra);
    }
    Ok(())
}

// ---- remote speakers (updateSpeakingData) ---------------------------------------------------------

/// `["speaker:direct", [peerId, kind, babel, volume, emitterPosASL, emitterDir]]` with kind
/// `d` (direct), `i` (intercom), `z` (zeus), `s` (spectator), `g` (god).
fn speaker_direct(
    peer: u32,
    kind: String,
    babel: bool,
    volume: f32,
    position: [f32; 3],
    direction: [f32; 3],
) -> Result<(), String> {
    let kind = DirectKind::parse(&kind).ok_or_else(|| format!("unknown kind {kind}"))?;
    let st = state();
    {
        let mut render = st.render();
        if let Some(s) = render.speakers.get_mut(&PeerId(peer)) {
            s.muted = false;
            s.direct = Some(DirectParams {
                kind,
                babel,
                volume,
                position,
                direction,
            });
        }
    }
    // Spectators and god mode are heard at any distance (ACRE2Core unmuted them too).
    if matches!(kind, DirectKind::Spectate | DirectKind::God) {
        unmute(&st, peer);
    }
    Ok(())
}

/// `["speaker:radio", [peerId, babel, [[volume, signal, loudspeaker, posASL], …]]]`: our radios
/// hearing the speaker. Headset radios use position `[ear * 2, 0, 0]`.
fn speaker_radio(peer: u32, babel: bool, radios: Vec<(f32, f32, bool, [f32; 3])>) {
    let st = state();
    {
        let mut render = st.render();
        if let Some(s) = render.speakers.get_mut(&PeerId(peer)) {
            s.muted = false;
            s.radio_babel = babel;
            s.radios = radios
                .into_iter()
                .map(|(volume, signal, loudspeaker, position)| RadioOut {
                    volume,
                    signal,
                    loudspeaker,
                    position,
                })
                .collect();
        }
    }
    // Heard over the radio: lift distance muting now rather than at the next muting pass, as
    // ACRE2Core did.
    unmute(&st, peer);
}

fn unmute(st: &State, peer: u32) {
    if let Some(s) = &st.session {
        s.mixer().set_muted(PeerId(peer), false);
    }
}

/// `["speaker:silence", [peerId]]`: not audible right now (`updateSpeakingData` "m").
fn speaker_silence(peer: u32) {
    let st = state();
    if let Some(s) = st.render().speakers.get_mut(&PeerId(peer)) {
        s.muted = true;
    }
}

/// `["speaker:mute", [peerId, muted]]`: lasting local mute (`setMuted`).
fn speaker_mute(peer: u32, muted: bool) {
    let st = state();
    if let Some(s) = &st.session {
        s.mixer().set_muted(PeerId(peer), muted);
    }
}

// ---- settings -------------------------------------------------------------------------------

/// `["settings:curve_model", [ACRE_VOICE_CURVE_MODEL]]`
fn settings_curve_model(model: i64) {
    state().render().curve_model = CurveModel::from_index(model);
}

/// `["settings:set", [name, value]]`: `globalVolume`, `premixGlobalVolume`, `radioNoise`.
fn settings_set(name: String, value: f32) -> Result<(), String> {
    let st = state();
    let mut r = st.render();
    match name.as_str() {
        "globalVolume" => r.global_volume = value.max(0.0),
        "premixGlobalVolume" => r.premix_volume = value.max(0.0),
        "radioNoise" => r.radio_noise = value != 0.0,
        other => return Err(format!("unknown setting {other}")),
    }
    Ok(())
}

/// `["settings:override", [enabled]]` (`setSoundSystemMasterOverride`).
fn settings_override(enabled: bool) {
    state().render().master_override = enabled;
}

// ---- sounds ---------------------------------------------------------------------------------

/// `["sound:load", [id, base64Wav]]` → `true` once loaded.
fn sound_load(id: String, base64: String) -> Result<bool, String> {
    let samples = sounds::decode(&base64)?;
    state().render().sounds.insert(id, samples.into());
    Ok(true)
}

/// `["sound:play", [id, posASL, dir, volume, isWorld]]` → `false` if not loaded.
fn sound_play(
    id: String,
    position: [f32; 3],
    direction: [f32; 3],
    volume: f32,
    world: bool,
) -> bool {
    state()
        .render()
        .play_sound(&id, position, direction, volume, world)
}

// ---- audio devices --------------------------------------------------------------------------

/// `["audio:devices", []]` → `[[[id, name], …inputs], [[id, name], …outputs]]`
/// `[id, name]` pairs.
type DeviceNames = Vec<(String, String)>;

fn audio_devices() -> (DeviceNames, DeviceNames) {
    let d = list_devices();
    let pairs = |v: Vec<acre2_voice_client::audio::AudioDevice>| {
        v.into_iter().map(|d| (d.id, d.name)).collect()
    };
    (pairs(d.inputs), pairs(d.outputs))
}

/// `["audio:select", [inputId, outputId]]` (`""` for the system default).
fn audio_select(input: String, output: String) {
    let mut st = state();
    let nonempty = |s: String| (!s.is_empty()).then_some(s);
    st.wanted.input = nonempty(input);
    st.wanted.output = nonempty(output);
    if let Some(s) = &st.session {
        s.set_devices(st.wanted.input.clone(), st.wanted.output.clone());
    }
}

/// `["audio:level", []]` → microphone level in dBFS (for a settings meter).
fn audio_level() -> f32 {
    let st = state();
    match (&st.session, &st.monitor) {
        (Some(s), _) => s.mic_level_db(),
        (None, Some(m)) => m.level_db(),
        (None, None) => -100.0,
    }
}

/// `["audio:monitor", [enabled]]`: keeps the microphone open for `audio:level` while not
/// connected (the mic test). Connected sessions always measure.
fn audio_monitor(enabled: bool) {
    let mut st = state();
    if enabled {
        if st.monitor.is_none() {
            let input = st.wanted.input.clone();
            let noise = st.wanted.noise;
            st.monitor = Some(MicMonitor::start(input, Arc::new(|_| {}), noise));
        }
    } else {
        let old = st.monitor.take();
        drop(st);
        drop(old);
    }
}

/// `["voice:stats", []]` → `[state, peerId, address, rttMs, sentLossPct, receivedLossPct,
/// kbitInPerSec, kbitOutPerSec, speakingNow, lastError]`. Rates are since the previous call.
fn stats() -> (String, u32, String, f64, f64, f64, f64, f64, u32, String) {
    let mut st = state();
    let (state_name, peer) = match &st.session {
        Some(s) => ("connected", s.client().peer_id().0),
        None if st.connecting => ("connecting", 0),
        None => ("disconnected", 0),
    };
    let Some(session) = st.session.clone() else {
        return (
            state_name.into(),
            0,
            st.address.clone(),
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0,
            st.last_error.clone(),
        );
    };
    let now = std::time::Instant::now();
    let conn = session.client().stats();
    let (kbit_in, kbit_out) = match st.last_stats {
        Some((then, prev)) => {
            let secs = now.duration_since(then).as_secs_f64().max(0.001);
            (
                (conn.rx_bytes.saturating_sub(prev.rx_bytes)) as f64 * 8.0 / 1000.0 / secs,
                (conn.tx_bytes.saturating_sub(prev.tx_bytes)) as f64 * 8.0 / 1000.0 / secs,
            )
        }
        None => (0.0, 0.0),
    };
    st.last_stats = Some((now, conn));
    let sent_loss = if conn.sent_packets == 0 {
        0.0
    } else {
        conn.lost_packets as f64 / conn.sent_packets as f64 * 100.0
    };
    let (received_loss, speaking) = {
        let mixer = session.mixer();
        (mixer.totals().loss() * 100.0, mixer.playing() as u32)
    };
    (
        state_name.into(),
        peer,
        st.address.clone(),
        conn.rtt.as_secs_f64() * 1000.0,
        sent_loss,
        received_loss,
        kbit_in,
        kbit_out,
        speaking,
        String::new(),
    )
}

/// Our own looped-back transmissions in the mixer, and whether we're rendering them (tests).
#[cfg(test)]
pub(crate) fn own_streams() -> (usize, bool) {
    let st = state();
    let Some(s) = &st.session else {
        return (0, false);
    };
    let me = s.client().peer_id();
    let streams = s.mixer().streams().filter(|(i, _)| i.speaker == me).count();
    let rendered = st
        .render()
        .speakers
        .get(&me)
        .is_some_and(|sp| sp.primary.is_some());
    (streams, rendered)
}

/// The client command groups, e.g. `voice:connect`.
pub fn groups() -> Vec<(&'static str, Group)> {
    vec![
        (
            "voice",
            Group::new()
                .command("connect", connect)
                .command("disconnect", disconnect)
                .command("status", status)
                .command("stats", stats),
        ),
        (
            "tx",
            Group::new()
                .command("direct", tx_direct)
                .command("start", tx_start)
                .command("stop", tx_stop)
                .command("stop_all", tx_stop_all)
                .command("loopback", tx_loopback),
        ),
        ("rx", Group::new().command("channels", rx_channels)),
        (
            "vox",
            Group::new()
                .command("settings", vox_settings)
                .command("ptt", vox_ptt)
                .command("mute", vox_mute)
                .command("noise", vox_noise),
        ),
        (
            "self",
            Group::new()
                .command("update", self_update)
                .command("positions", self_positions),
        ),
        (
            "speaker",
            Group::new()
                .command("direct", speaker_direct)
                .command("radio", speaker_radio)
                .command("silence", speaker_silence)
                .command("mute", speaker_mute),
        ),
        (
            "settings",
            Group::new()
                .command("curve_model", settings_curve_model)
                .command("set", settings_set)
                .command("override", settings_override),
        ),
        (
            "sound",
            Group::new()
                .command("load", sound_load)
                .command("play", sound_play),
        ),
        (
            "audio",
            Group::new()
                .command("devices", audio_devices)
                .command("select", audio_select)
                .command("level", audio_level)
                .command("monitor", audio_monitor),
        ),
    ]
}
