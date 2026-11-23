//! Player-side commands: connecting, transmitting, and the parameters SQF feeds the renderer.
//!
//! Settings made while disconnected are kept and applied on (re)connect.

use std::{
    collections::{BTreeMap, HashMap},
    sync::{Arc, LazyLock, Mutex, MutexGuard},
};

use acre2_dsp::positional::{CurveModel, Listener, from_arma};
use acre2_voice_client::{
    Client,
    audio::{
        ActivationConfig, ActivationMode, Outgoing, SessionConfig, SessionEvent, VoiceSession,
        list_devices,
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
    render::{AcreRenderer, DirectKind, DirectParams, RadioOut, RenderState, SharedState},
    runtime, sounds,
    speakers::{SpeakingEvent, Tracker},
};

#[derive(Debug, Default)]
struct Wanted {
    activation: ActivationConfig,
    input: Option<String>,
    output: Option<String>,
    direct: Option<(Outgoing, Meta)>,
    keyed: BTreeMap<TxId, (Outgoing, Meta)>,
    direct_ptt: bool,
    muted: bool,
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
}

static STATE: LazyLock<Mutex<State>> = LazyLock::new(|| {
    Mutex::new(State {
        render: Arc::default(),
        tracker: Tracker::default(),
        session: None,
        connecting: false,
        generation: 0,
        wanted: Wanted::default(),
        keys: HashMap::new(),
        tx_meta: HashMap::new(),
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
                Some((o, _)) => t.key(*tx, o.clone()),
                None => t.unkey(*tx),
            }
        }
    }

    fn take_session(&mut self) -> Option<Arc<VoiceSession>> {
        self.generation += 1;
        self.connecting = false;
        let events = {
            let mut st = self.render.lock().expect("render state");
            self.tracker.clear(&mut st)
        };
        emit_speaking(events);
        self.session.take()
    }
}

fn emit_speaking(events: Vec<SpeakingEvent>) {
    for e in events {
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

/// `["voice:connect", [address, tokenHex, fingerprintHex]]`. Answers with the `connected`
/// (`[peerId]`) or `connect_failed` (`[reason]`) callback.
fn connect(address: String, token: String, fingerprint: String) -> Result<(), String> {
    let token = Token::from_hex(&token).ok_or("invalid token")?;
    let fingerprint = parse_fingerprint(&fingerprint).ok_or("invalid fingerprint")?;
    let (old, generation, render, config) = {
        let mut st = state();
        let old = st.take_session();
        st.connecting = true;
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
                st.apply();
                drop(st);
                std::thread::Builder::new()
                    .name("acre2-events".into())
                    .spawn(move || pump_events(&session_events, generation))
                    .expect("spawning event thread");
                emit("connected", peer.0);
            }
            Err(e) => {
                tracing::warn!(error = %e, %address, "could not connect to voice server");
                drop(st);
                emit("connect_failed", e);
            }
        }
    });
    Ok(())
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
                emit_speaking(events);
            }
            SessionEvent::Server(ServerMsg::TransmissionEnded { speaker, tx }) => {
                let events = {
                    let State {
                        render, tracker, ..
                    } = &mut *st;
                    tracker.ended(&mut render.lock().expect("render state"), speaker, tx)
                };
                drop(st);
                emit_speaking(events);
            }
            SessionEvent::Server(ServerMsg::Error { message }) => {
                drop(st);
                tracing::warn!(%message, "voice server refused a request");
                emit("server_error", message);
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
                emit("device", format!("{d:?}"));
            }
            SessionEvent::Closed { reason } => {
                let old = st.take_session();
                drop(st);
                drop(old);
                tracing::info!(%reason, "disconnected from voice server");
                emit("disconnected", reason);
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

/// `["vox:settings", ["vad" | "ptt", thresholdDb]]`
fn vox_settings(mode: String, threshold_db: f32) -> Result<(), String> {
    let mode = match mode.as_str() {
        "vad" => ActivationMode::Voice,
        "ptt" => ActivationMode::PushToTalk,
        other => return Err(format!("unknown mode {other}")),
    };
    let mut st = state();
    st.wanted.activation = ActivationConfig {
        mode,
        threshold_db,
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
    Ok(())
}

/// `["speaker:radio", [peerId, babel, [[volume, signal, loudspeaker, posASL], …]]]`: our radios
/// hearing the speaker. Headset radios use position `[ear * 2, 0, 0]`.
fn speaker_radio(peer: u32, babel: bool, radios: Vec<(f32, f32, bool, [f32; 3])>) {
    let st = state();
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
    state()
        .session
        .as_ref()
        .map_or(-100.0, |s| s.mic_level_db())
}

/// The client command groups, e.g. `voice:connect`.
pub fn groups() -> Vec<(&'static str, Group)> {
    vec![
        (
            "voice",
            Group::new()
                .command("connect", connect)
                .command("disconnect", disconnect)
                .command("status", status),
        ),
        (
            "tx",
            Group::new()
                .command("direct", tx_direct)
                .command("start", tx_start)
                .command("stop", tx_stop)
                .command("stop_all", tx_stop_all),
        ),
        ("rx", Group::new().command("channels", rx_channels)),
        (
            "vox",
            Group::new()
                .command("settings", vox_settings)
                .command("ptt", vox_ptt)
                .command("mute", vox_mute),
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
                .command("level", audio_level),
        ),
    ]
}
