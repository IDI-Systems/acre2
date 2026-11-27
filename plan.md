# ACRE without TeamSpeak — Plan

Living document. Update the checkboxes and the **Decisions** / **Open questions** sections as work progresses.

## Goals

1. **Voice library**: a general-purpose game voice chat library in Rust, with a server and a client. Opus codec tuned for game chat. The server knows where players are (for local/direct voice) and which channels (radio frequencies etc.) they're on, and only forwards audio to clients that can hear it.
2. **New ACRE extension**: a Rust extension built on that library and [arma-rs](https://github.com/BrettMayson/arma-rs). It replaces the TS3 plugin, the named pipe and the string-splitting RPC with typed `callExtension` arguments and extension callbacks.

## Decisions (made)

| # | Decision | Notes |
|---|----------|-------|
| D1 | ~~Standalone voice server, fed by Arma~~ → **hosted inside the Arma server's extension** (D10) | The server/authority split stays (the authority is just a local QUIC connection now), and `acre2_voice_server` still builds as a standalone binary for testing. |
| D2 | **Scope: pipe + DSP now, signal later** | Replace `ACRE2Arma/arma2ts` (pipe), `ACRE2Core` (TS plugin DSP) and drop `ACRE2Steam` and `ACRE2TS`. Keep `acre.dll` (signal/terrain/antenna, `fnc_callExt`) unchanged for now and port it in a later phase. |
| D3 | **Hard cut from TS3** | No backend abstraction. TS3 users stay on the last 2.x release. |
| D4 | **Cargo workspace in `rust/`** | A separate `rust/` directory keeps it apart from the C++ in `extensions/`. Crates use the `acre2_` prefix. The voice library crates stay free of ACRE/Arma code so they could be split out later. |
| D5 | **Windows x64 client, Windows + Linux x64 server** | Arma 3 is 64-bit only, so drop the 32-bit DLLs. Dedicated servers on Linux need the server-side extension `.so` and the voice server binary. |
| D6 | **Direct speech: voice activation by default, push-to-talk optional** | CBA settings: activation mode (voice activation / push-to-talk) and voice-activation sensitivity (threshold, with a live mic level meter if feasible). A CBA keybind for direct push-to-talk. The extension does the activation detection; SQF only sets the mode, threshold and key state. |
| D7 | **Clients report their radio rx subscriptions** | This is only a bandwidth optimisation (a modded client can eavesdrop on any radio anyway), and the server SQF doesn't have cheap access to every player's tuned radios. Positions and identity still come from the authority. |
| D8 | **Clients can report extra positions when the authority allows it** | Zeus (camera comms) and spectators speak or listen from the camera, which only the client knows. Today the Zeus client already broadcasts `zeusPosition` = `[getPosASL curatorCamera, getCameraViewDirection curatorCamera]` as a public variable every 0.2 s ([sys_zeus/fnc_handleZeusSpeakPress.sqf](addons/sys_zeus/fnc_handleZeusSpeakPress.sqf)). The library supports this generically: a peer has an authority position plus client-reported *extra positions* (`emitter` and/or `listener`). The client may report them only while the authority has granted that peer the matching permission (e.g. while it's a curator or spectator). See "Positions" below. |
| D9 | **Any PTT always opens the mic** | Holding any push-to-talk key (direct PTT, radio PTT, intercom, Zeus, god mode) transmits regardless of the voice-activation threshold. Direct speech is also sent while a radio PTT is held, as today. Voice activation only gates direct speech when no PTT is held. |
| D10 | **The Arma server hosts the voice server** | `["server:start", [port, address]]` binds UDP `port` in the extension and connects to it locally as the authority with a random in-memory secret, so there's no config file or secret. Port and public address come from CBA server settings (`acre_sys_server_voicePort`, default 9987, and `acre_sys_server_voiceAddress`, required) or `ACRE2_VOICE_PORT` / `ACRE2_VOICE_ADDRESS`, which take priority. |

## Current architecture (what we're replacing)

```
Arma (SQF) ──callExtension "2name:a,b,c,"──► ACRE2Arma.dll ──named pipe──► ACRE2TS (TS3 plugin)
     ▲                                                                       │  ACRE2Core: RpcEngine,
     └──── polled every frame: callExtension "3" (sys_io serverReadLoop) ◄──┘  SoundEngine/Mixer, DSP
                                                                             │
                                              TS3 server ◄── voice + plugin commands ──► other clients
```

- **Every** client in the TS channel receives **all** voice. Each listener's plugin mutes/unmutes and applies effects based on params that its own SQF computes (`updateSpeakingData`).
- The RPC format is `name:p1,p2,...,` (comma-split strings, bools as 0/1, nested arrays flattened). See [sys_rpc/fnc_callRemoteProcedure.sqf](addons/sys_rpc/fnc_callRemoteProcedure.sqf).
- Reads are polled up to 50 times per frame. See [sys_io/fnc_serverReadLoop.sqf](addons/sys_io/fnc_serverReadLoop.sqf).
- Radio signal quality is computed **listener-side** in SQF + `acre.dll` (terrain/antenna model), then passed to the DSP.

### RPC inventory

**Arma → plugin** (via `callRemoteProcedure`): `updateSelf`, `updateSpeakingData` (types `d`/`i`/`z`/`r`/`m`/`g`/`s`), `setHeadVector`, `setMuted`, `localMute`, `start/stop{Radio,Intercom,Zeus,GodMode}Speaking`, `setPTTKeys`, `setSetting`, `setSelectableVoiceCurve`, `setVoiceCurveModel`, `setSoundSystemMasterOverride`, `loadSound`, `playSound`, `ping`, `getPluginVersion`, `getClientID`, `getVOIP{Channel,Server}{Name,UID}`, `setTs3ChannelDetails`, `ext_reset`.

**Plugin → Arma** (`sys_rpc,addProcedure`): `handleGetClientID`, `handleGetPluginVersion`, `handleGetHeadVector`, `handleGetVOIP*`, `remoteStartSpeaking`, `remoteStopSpeaking`, `localStartSpeaking`, `localStopSpeaking`, `handleLoadedSound`, `pong`, `gen`.

**Plugin ↔ plugin** (TS plugin commands): `ext_remoteStartSpeaking` / `ext_remoteStopSpeaking` (id, languageId, netId, speakingType, radioId, curveScale), `ext_handleGetClientID`.

## Target architecture (as built)

```
 Arma dedicated server: acre_voice_x64 (.dll/.so)
 ┌────────────────────────────────────────────────────────────┐
 │ voice server (sessions · world · subscriptions · router)    │◄── UDP port (QUIC) ──┐
 │        ▲ local QUIC, random secret                          │                      │
 │ authority: positions @10 Hz, join tokens, camera permission │                      │
 └────────────────────────────────────────────────────────────┘                      │
      ▲ SQF (typed callExtension + ExtensionCallback); tokens to clients via CBA events  │
                                                                                         │
 Arma client: acre_voice_x64.dll                                                       │
  · mic → voice activation/PTT → Opus → datagrams ───────────────────────────────────────┤
  · datagrams → jitter buffer → decode → ACRE DSP (per speaker, params from SQF) → mixer ◄┘
```

### Workspace layout

```
rust/
  Cargo.toml           workspace
  voice/
    proto/             acre2_voice_proto    wire types, framing, versioning (no I/O)
    codec/             acre2_voice_codec    Opus wrapper, FEC/DTX config, jitter buffer, PLC
    server/            acre2_voice_server   lib: sessions, world state, routing; + bin `acre2_voice_server`
    client/            acre2_voice_client   lib: connection, capture/playback (cpal), activation, send/recv pipeline, mixer hooks
    testkit/           acre2_voice_testkit  harness, e2e/audio/load tests, acre2_voice_cli
  acre/
    dsp/               acre2_dsp            port of ACRE2Core effects (radio, babel, volume, positional)
    ext/               acre2_ext            cdylib `acre_voice_x64` (arma-rs): voice client + hosted server/authority
```

The TeamSpeak C++ was removed in Phase 6; `extensions/` now only holds the signal extension (`acre_x64`).

### Library concepts (generic, no ACRE knowledge)

- **Peer**: an authenticated client session with `peer_id: u32` and an opaque `external_id` (ACRE: Steam UID).
- **World state**: per peer, an authority `position: [f32; 3]`, `alive/active` and optional `group` tags. Only the authority writes these. Positions are interpolated server-side between updates.
- **Positions**: each peer has an authority position, plus optional client-reported **extra positions**, each tagged `emitter`, `listener` or both. The client may set these only while the authority grants the `report_position` permission. The authority revokes the permission (and the server clears the positions) when the player leaves Zeus or spectator.
  - *Speaking*: a spatial transmission is emitted from the `emitter` position if one is set, otherwise from the authority position. This mirrors today's Zeus camera comms.
  - *Listening*: a peer is in range if **any** of its listener positions (the authority position plus any `listener` extras) is in range. This mirrors today's Zeus rule that "the closer of the camera and the body wins".
  - Rate-limit the reports (e.g. 10 Hz) and optionally clamp them to sane bounds (inside the map, maximum speed).
- **Channel**: a string-keyed audio channel, e.g. `radio:43.100`, `intercom:<vehicleNetId>:crew`, `zeus`, `god:<group>`. Peers **subscribe** (rx) to channels.
- **Spatial channel**: a built-in "direct" channel. Recipients are peers within `range` metres of the speaker (the range comes from the voice curve; the server pads it generously and listener DSP does the real attenuation).
- **Transmission**: a speaker starts a transmission with `targets: Vec<Target>` (Spatial{range} | Channel(key)) and opaque `metadata: Bytes`, then streams Opus frames tagged with `tx_id`. The server resolves the recipient set at start and re-resolves it periodically (people move, subscribe, or unsubscribe). Recipients get `TransmissionStart{speaker, tx_id, matched_targets, metadata}` → frames → `TransmissionEnd`.
- A speaker can have several concurrent transmissions (direct + radio at once), and a recipient may match the same transmission through several targets. It receives one stream, plus the list of matched targets.
- **Permissions**: the authority can restrict who may transmit or subscribe to channel prefixes (e.g. `god:*`, `zeus`).

### Transport & security

- **QUIC via `quinn`**: one bidirectional reliable stream for control messages (serde + postcard or bincode) and **unreliable datagrams** for voice frames. QUIC gives us encryption, congestion awareness and NAT-friendly single UDP port for free.
- **Certificates**: the server generates a self-signed cert at startup. Its SHA-256 fingerprint travels with the join token: voice server → authority → Arma server → `remoteExec` → client. The client pins it, so the trust chain is Arma's own network.
- **Join flow**:
  1. The Arma server's extension hosts the voice server and connects to it locally as the authority, with a secret generated in memory (D10).
  2. When a player joins the mission, the server ext requests a token for their UID. The voice server returns `{token, addr, fingerprint}`.
  3. The client asked via `remoteExecCall` (the server identifies it by `remoteExecutedOwner`); the server answers with a CBA owner event. The client ext connects and presents the token, which is single-use and has a short TTL.
  4. The voice server maps peer ↔ UID ↔ unit (netId). The authority keeps the unit mapping current on respawn and team switch.
- **Voice datagram**: `[tx_id: u16][seq: u16][flags: u8][opus payload]`, kept ≤ ~200 B. The server stamps `speaker peer_id` when forwarding.

### Codec & audio pipeline

- **Opus** (`audiopus`/`opus` crate, libopus statically linked): 48 kHz mono, `Application::Voip`, 20 ms frames (10 ms as a setting), ~24–32 kbps VBR, in-band FEC on, DTX on, expected packet loss fed from receiver stats.
- **Capture**: `cpal` (WASAPI), resampling with `rubato` when the device isn't 48 kHz. Optional noise suppression (`nnnoiseless`, an RNNoise port), simple AGC, and VAD (energy + RNNoise VAD prob).
- **Receive**: an adaptive jitter buffer per transmission (target 40–60 ms), Opus PLC/FEC on loss, decode, then the **ACRE DSP chain per speaker** using the params from SQF, then the mixer, then the `cpal` output stream.
- **Local audio**: `loadSound`/`playSound` (radio beeps, squelch) go through the same mixer.
- Audio threads never block on SQF. Params live in lock-free / `arc-swap` snapshots updated by `callExtension`.

### How ACRE maps onto it

| ACRE concept | Library |
|---|---|
| Direct speech (`d`), shouting/whisper curve | Spatial target; `range` from `setSelectableVoiceCurve`/curve scale |
| Radio TX on radio X | Spatial target + channel `radio:<mode>:<freq>` (see Implementation notes) plus metadata `{speakingType, radioId, netId, languageId, curveScale}` |
| Radio RX | The client subscribes to the channels of all radios it has powered on and tuned, and re-syncs when radios change |
| Intercom (`i`) | Spatial target (crew are close); the listener's SQF decides it's intercom, as before |
| Zeus (`z`) | Spatial target. The client reports the curator camera as its `emitter` and `listener` extra position (D8). The authority grants `report_position` while the player is a curator. Listeners keep the current emitter-position DSP logic, which reads `zeusPosition`. That variable broadcast can later be replaced by the position sent in the transmission. |
| God mode (`g`) | Channel `god` (everyone listens); the listener's SQF filters by target group, as before |
| Spectator (`s`) | Channel `spectator`. The spectator camera is reported as a `listener` extra position (D8) where spatial hearing applies |
| Babel/languages | Metadata `languageId`. The listener applies the babel effect as today |
| Signal quality, radio distortion | Still listener-side: SQF + `acre.dll` compute it and pass it to the DSP via `speaker:radio` (same as before) |
| `remoteStartSpeaking` / `remoteStopSpeaking` | Fired from the ext as `ExtensionCallback` on TransmissionStart/End |

The server-side routing for radio is **frequency only** (no distance cut). The listener decides audibility and quality, as today. Direct speech gets a distance cut, which is where the bandwidth savings are.

### Extension API (arma-rs)

`"acre_voice" callExtension ["group:command", [args…]]`, typed arguments; asynchronous results and events come through `ExtensionCallback` (name `"acre_voice"`, data always an SQF array). This replaces the per-frame `sys_io` polling. Each command is documented where it's defined:

- Player side ([client.rs](rust/acre/ext/src/client.rs)): `voice:connect/disconnect/status`, `tx:direct/start/stop/stop_all/loopback`, `rx:channels`, `vox:settings/ptt/mute`, `self:update/positions`, `speaker:direct/radio/silence/mute`, `settings:curve_model/set/override`, `sound:load/play`, `audio:devices/select/level`. Callbacks: `connected`, `connect_failed`, `disconnected`, `remote_start`, `remote_stop`, `local_start`, `local_stop`, `server_error`, `device`.
- Server side ([host.rs](rust/acre/ext/src/host.rs), [authority.rs](rust/acre/ext/src/authority.rs)): `server:start/stop`, `authority:connect/token/world/remove/rules/report_position/status`. Callbacks: `authority_connected`, `authority_failed`, `authority_disconnected`, `token`, `token_failed`, `peer_connected`, `peer_disconnected`, `authority_error`.
- `init` (once, enables callbacks), `version`.

## Phases

### Phase 0 — Scaffolding
- [x] Cargo workspace + crates as above, `rust-toolchain.toml`, clippy/fmt config
- [x] CI: [.github/workflows/rust.yml](.github/workflows/rust.yml) runs fmt, clippy (`-D warnings`) and tests, then builds `acre_voice_x64.dll` (Windows MSVC) and `acre_voice_x64.so` (Linux) plus the standalone `acre2_voice_server` as artifacts
- [x] Rust artifacts in [tools/make.py](tools/make.py) and [release.yml](.github/workflows/release.yml) (Phase 6)
- [x] Decide crate names and location (D4: `rust/`, `acre2_` prefix)

### Phase 1 — Voice library core
- [x] `proto`: control messages, datagram format, framing, protocol version handshake
- [x] `server`: QUIC endpoint, authority link, token issuing, sessions, world state, subscriptions, router (spatial + channel), periodic re-resolve, channel rules
- [x] `server`: extra positions (D8): permission gate, multiple listener positions, emitter override
- [x] `server`: per-client token buckets: voice 250 datagrams/s (excess dropped, oversized payloads dropped), control 50 msg/s burst 200 (sustained excess disconnects)
- [ ] `server`: optional sanity clamp on reported camera positions
- [x] `server` bin: TOML config ([example](rust/voice/server/acre2_voice_server.example.toml)), logging (`RUST_LOG`), cert persistence + `fingerprint.txt`
- [x] `client`: connect with token + fingerprint pin, control stream, datagram send/recv; `Authority` with `issue_token`/`ping`/world/rules
- [ ] `client`: reconnect/backoff (needs a fresh token from the authority, so it belongs partly to the ext)
- [x] `codec`: Opus encode/decode (speech-tuned, 24 kbps VBR, FEC, DTX), adaptive jitter buffer, FEC recovery + PLC, per-stream stats
- [x] `testkit`: in-process harness (server + authority + bots) and 13 end-to-end tests over real QUIC (routing, rules, Zeus camera, tokens, kicks, pinning)
- [x] `testkit`: speaker/listener bots through the real transmitter → server → mixer path, asserting latency (<150 ms) and FEC recovery under 10% loss ([audio.rs](rust/voice/testkit/tests/audio.rs)), with a synthetic speech signal
- [ ] `testkit`: bursty-loss/reordering/jitter simulation (currently only periodic loss)
- [x] Load test ([load.rs](rust/voice/testkit/tests/load.rs), `--ignored`): 120 peers / 24 speakers → 100% delivered, 27.7k datagrams/s, 15 Mbit/s; 250 peers / 50 speakers → 100% delivered, 125k datagrams/s, 69 Mbit/s, 61% of one core *including all 250 client endpoints* (release build, localhost)

### Phase 2 — Client audio
- [x] `cpal` capture/playback, device enumeration by stable id (`alsa:…`, `wasapi:…`) and selection, reopen on device change (`VoiceSession::set_devices`)
- [ ] Hot-plug: reopen automatically when a device disappears (currently reported as a `DeviceEvent` error)
- [x] Resampling (cubic, streaming) and downmix
- [x] Noise suppression and speech-only voice activation (`nnnoiseless`, on by default in ACRE; CBA settings *Noise suppression*, *Voice activation: speech only*)
- [ ] AGC
- [x] Loopback: a keyed transmission can also be played back locally (`Transmitter::set_loopback`), as a stream from our own peer id (ACRE: hearing yourself on a second radio)
- [x] Activation (D6/D9): voice activation with threshold + hangover, direct PTT, any held PTT opens the mic, mute; mic level for a meter
- [x] Mixer: per-stream jitter buffers, `Renderer` hook for per-speaker effects, local mute, soft clip
- [ ] Mixer: local sounds (`loadSound`/`playSound`) — will live in the ACRE renderer (Phase 4)
- [x] Standalone test app [`acre2_voice_cli`](rust/voice/testkit/src/bin/acre2_voice_cli.rs) (`devices`, `talk` with voice activation or `--ptt`, `--radio`); smoke-tested server + two clients on null devices

### Phase 3 — ACRE DSP port (`acre/dsp`)
- [x] Inventory: in use were `FilterRadio` (+ `PinkNoise`, ring modulation, foldback, RBJ biquads), `BabbelEffect`, `FilterVolume` and `FilterPosition` (X3DAudio). `FilterOcclusion`, `FilterGain`, `AmplitudeAttenuation` and `BabelFilter` were dead code and are not ported
- [x] Ported to [acre2_dsp](rust/acre/dsp), processing in TeamSpeak's 480-sample blocks where the originals restart per block
- [x] Golden tests: [reference/generate.sh](rust/acre/dsp/reference/generate.sh) builds the original C++ effects with g++ and writes outputs. Radio matches within 1 LSB (70–75 dB SNR), babel ~47 dB (the C++ rounds to `i16` between stages). Noise can't be compared (it used `rand()`)
- [x] Voice curve models 0–3 and selectable curve scale; ACRE's 151-point distance table; kill fade
- [x] Positional: X3DAudio (Windows-only, closed) replaced by a documented reimplementation: distance curves, emitter cone (1.2× front), equal-power stereo pan with a 2 m inner radius, the headset "ear" positions. Exact X3DAudio panning can't be matched; worth a listening test (Q12)

### Phase 4 — ACRE extension (`acre/ext`, built as `acre_voice_x64`)
- [x] arma-rs client commands (`voice:*`, `tx:*`, `rx:*`, `vox:*`, `self:*`, `speaker:*`, `settings:*`, `sound:*`, `audio:*`) and `ExtensionCallback` events, documented in [client.rs](rust/acre/ext/src/client.rs)
- [x] Authority commands (`authority:connect/token/world/remove/rules/report_position/status`), [authority.rs](rust/acre/ext/src/authority.rs); `server:start/stop` host the voice server ([host.rs](rust/acre/ext/src/host.rs), D10)
- [x] Every RPC mapped (see table below); `AcreRenderer` runs the ported chains per speaker; [speakers.rs](rust/acre/ext/src/speakers.rs) merges a speaker's streams into ACRE's single speaking state
- [x] Logging to `%LOCALAPPDATA%\Arma 3\acre2_ext.log`; command errors return non-zero codes (logged by `acre_sys_io_fnc_ext`)
- [x] In-process e2e test with the arma-rs harness: server + extension as authority (token) and as player (connect, voice activation, radio PTT, disconnect)

| TS3 RPC | Now |
|---|---|
| `updateSelf`, `setHeadVector` | `self:update` |
| `updateSpeakingData` d/i/z/s/g, r, m | `speaker:direct`, `speaker:radio`, `speaker:silence` |
| `setMuted` / `localMute` | `speaker:mute` / `vox:mute` |
| `start/stop{Radio,Intercom,Zeus,GodMode}Speaking` | `tx:start` / `tx:stop` (via `acre_sys_core_fnc_start/stopTransmission`) |
| `setVoiceCurveModel`, `setSelectableVoiceCurve` | `settings:curve_model`; curve scale travels in transmission metadata |
| `setSetting`, `setSoundSystemMasterOverride` | `settings:set`, `settings:override` |
| `loadSound`, `playLoadedSound` | `sound:load` (whole base64 WAV), `sound:play` |
| `remoteStart/StopSpeaking`, `localStart/StopSpeaking` | callbacks `remote_start/stop`, `local_start/stop` |
| `getClientID`/`handleGetClientID` | peer ID from `connected`, published as a unit variable |
| `getPluginVersion`, `getVOIP*`, `setTs3ChannelDetails`, `ping`/`pong`, `gen`, `ext_reset` | removed |

### Phase 5 — SQF migration
- [x] `sys_io` rewritten (`fnc_ext`, `fnc_handleCallback`, token flow, reconnects); `sys_rpc` deleted
- [x] Server: `startAuthority` (hosts the voice server from the CBA settings once they're loaded), `voiceStatePFH` (10 Hz world feed + camera permissions), `requestVoiceToken` via `remoteExecCall` (caller identified by `remoteExecutedOwner`; `CfgRemoteExec` entry), `authority:remove` on disconnect
- [x] All `callRemoteProcedure` sites converted
- [x] Rx subscriptions: `acre_sys_core_fnc_voiceStatePFH` polls hearable radios every 0.25 s and sends `rx:channels` when the set changes (simpler than hooking every radio event; Q13)
- [x] Peer IDs replace TS3 IDs (same `ts3id` variables, so the rest of SQF is unchanged)
- [x] TS-specific features removed (channel switching settings, VOIP info, plugin version check, Steam plugin installer); "not connected to the voice server" notifications
- [x] D6: CBA settings for activation mode, sensitivity, input/output device; Direct Speech PTT keybind (unbound by default); `acre_api_fnc_getAudioDevices`, `acre_api_fnc_getMicrophoneLevel`
- [x] D8: Zeus/spectator cameras → `self:positions`; server grants `report_position` to curators and spectators
- [x] Briefing: while ACRE's briefing override is on, direct speech also goes to a `briefing` channel everyone listens to (TS3 let everyone hear everyone then)
- [ ] **Run it in Arma.** None of the SQF has been executed yet; only the repo's validators (SQF, config, headers, stringtables) were run
- [ ] Zeus, spectator, god mode, intercom and babel parity checks in game
- [x] Device dropdowns (CBA lists filled from the extension at startup), separate voice activation open/close levels
- [x] Microphone test (Escape → Options, the map page, or `acre_api_fnc_openMicrophoneTest`): silence/typing/speech, suggests open/close levels or push-to-talk; works before connecting (`audio:monitor`)
- [x] "ACRE Voice" map diary page: connection, address, latency, packet loss sent/received, bandwidth, active speakers, mic settings (`voice:stats`)

### Phase 6 — Cleanup & release
- [x] Removed `ACRE2Arma/arma2ts`, `ACRE2Core`, `ACRE2TS`, `ACRE2DistortionTestPlugin`, `ACRE2Steam`; CMake updated. (`acre.dll`/`acre_x64.dll` signal extension stays until Phase 7.) **The remaining C++ build is unverified here (no MSVC)**
- [x] `tools/make.py`: packages `acre_voice_x64.dll`, builds it with cargo, drops the TeamSpeak plugin
- [x] Release workflow: builds `acre_voice_x64.dll` (signed with the rest) and `acre_voice_x64.so` for Linux dedicated servers (`compile-linux` job)
- [x] Docs: [installation](docs/wiki/user/installation.md) (players), [voice server](docs/wiki/user/voice-server.md) (admins: two settings and a port), building, tips; TS channel switching page removed
- [ ] Playtests with real groups at increasing size
- [ ] BattlEye: confirm `acre_voice_x64.dll` (networking + audio) is accepted once signed

### Phase 7 — Later
- [ ] Port `acre.dll` (signal, antenna, terrain/WRP loading, signal map) to Rust and merge it with `acre_voice` into one extension; drop `acre_dynload`
- [ ] Optional: server-side signal estimation for smarter radio routing

## Implementation notes

Details that later phases depend on, settled while building:

- **Default port** `9987/udp` (the TS3 port, so existing firewall rules keep working).
- **Control stream**: the client opens one bidirectional stream right after the handshake. First message `Hello`, answered by `Welcome` or `Rejected` (then the connection closes). The server limits connections to that one stream.
- **Close codes** (`acre2_voice_server::close_code`): 1 rejected, 2 kicked, 3 replaced (same player joined again, or a new authority connected), 4 protocol error, 5 server shutdown. The reason text reaches the client as `ClientEvent::Closed { reason }`.
- **Rejoining**: redeeming a token for a player who is already connected disconnects the old connection. One connection per player.
- **Authority reconnect**: a new authority with the right secret replaces the old one, and is sent `PeerConnected` for everyone already connected. World state survives authority reconnects.
- **Spatial routing**: one pass with the largest requested range, clamped to `max_spatial_range` (default 300 m). Inactive players neither emit nor hear from their authority position, but extra positions still apply (spectators).
- **Recipient updates**: `TransmissionStarted` is sent again only when the *kind* of match changes (spatial ↔ channel set). Spatial distance changes don't re-send, so walking around isn't chatty. Restarting a transmission with the same `tx` re-announces it to everyone (metadata may have changed).
- **Channel rules**: longest prefix wins. A player's own rules are checked before the global ones, and access is allowed when nothing matches. Tx is checked at start and on every re-resolve; rx on every resolve.
- **Voice before routes**: datagrams that arrive before the server has processed `StartTransmission` are dropped (at most a frame or two). The client should send `StartTransmission` as soon as the PTT or voice activation fires, before the first encoded frame is ready.
- **Barriers**: `Authority::ping()` and a client `Ping`/`Pong` guarantee everything sent earlier on that connection has been applied. The tests use these. The ext can use them after a world update when ordering matters.
- **Radio channel keys**: `radio:<mode>:<frequency, 5 decimals>` for `singleChannel`/`singleChannelPRR` (TX frequency when sending, RX when listening), `radio:sem70AKW:<hashValue of the frequency list>`, `radio:other:<mode>` for unknown modes. Other channels: `god` (everyone listens; SQF filters by target group), `spectator`, `briefing`.
- **What each speaking type targets**: direct = spatial (range from the curve model: 150 m × curve scale for selectable B, else 300 m); radio = spatial + its channel; intercom and Zeus = spatial; god = `god` only; spectators = `spectator` only.
- **Hosting**: the certificate is generated fresh each `server:start` (clients get the fingerprint with every token, so nothing is persisted). The address gets `:port` appended unless it has one.
- **Wine/Proton**: quinn's default Windows UDP socket fails there (`WSAEOPNOTSUPP`, OS error 10045: Wine rejects one of its socket options). [acre2_voice_net](rust/voice/net) falls back to a plain UDP socket (no ECN/packet info/GSO). Reproduced and verified by running the Windows build of the e2e suite under Wine.
- **Hosted server restarts**: restarting the hosted voice server detaches the authority first, so its connection closing isn't reported as the server being lost (that used to loop: lost → restart → lost, every 10 s).
- **Hosted server lifecycle**: `server:start`/`server:stop` return at once and run in order on one worker thread. Shutdown ends every connection task, but the socket is only released once closed connections drain (a few round trips to real players), so a restart on the same port retries the bind for up to 10 s. The server stops at `MPEnded`; clients then disconnect quietly and stop asking for tokens. `#restart` and `#missions` start a new mission without ending the old one: a `server:start` for the same port and address while the server is running keeps it (players stay connected, same certificate) and just reports `authority_connected` again, reconnecting the authority if it was lost. A different port or address restarts it.
- **Own transmissions in SQF**: TeamSpeak echoed our own stop back as `remoteStopSpeaking`, and that was what cleared `ACRE_BROADCASTING_RADIOID`. The extension doesn't, so `localStopSpeaking` clears it for a radio transmission. Without that, the radio you had transmitted on stayed "transmitting" and never received again (half duplex).
- **Distance muting**: speakers more than 300 m away are muted in the mixer. `speaker:radio` (and god/spectator `speaker:direct`) unmute them at once, as ACRE2Core's `updateSpeakingData` did, instead of waiting for the next muting pass.
- **Microphone filter**: RNNoise (`nnnoiseless`, pure Rust) runs on our own microphone before voice activation and encoding, ~0.4% of a core. Suppression removes steady noise (~20 dB+ on fan-like noise between words, speech level within a few dB). Speech detection: voice activation opens only after 2 frames in a row with speech probability ≥ 0.5 (single loud clicks can briefly score high); once open, the level alone keeps it open. Those 2 frames are buffered while idle and sent first (pre-roll), so the start of a word isn't lost. Synthetic white noise is a poor test signal for RNNoise (it sometimes reads it as speech); the tests use fan-like noise and keyboard clicks (`acre2_voice_testkit::signals`). The library's default is off; the extension turns both on (`vox:noise`).
- **Hearing yourself on a radio**: the server never sends a speaker their own voice, so with `tx:loopback` on (CBA *Hear yourself on other radios*) the session also feeds each radio transmission into its own mixer and events as a stream from our own peer id ([loopback.rs](rust/voice/client/src/audio/loopback.rs)). The extension tracks it like a remote speaker so it renders, but doesn't report it as `remote_start`/`remote_stop`. SQF's speaking loop processes us as a radio speaker on the transmitting radio while we transmit (`acre_sys_core_hearingSelf`), so our other radios on the channel, and loudspeaker radios near us, hear it through the usual signal and radio-effect path. The transmitting radio is skipped (half duplex). It goes through the jitter buffer, so it is heard about 40–60 ms late.
- **PTT release delay**: the existing `ACRE_PTT_RELEASE_DELAY` (radio and Zeus keys) is now a CBA setting (*Push-to-talk release delay*, default 0.2 s, still overridden by `acre_api_fnc_setPTTDelay`), and also applies to the direct, intercom and god mode PTT keys (`acre_sys_core_fnc_pttPressed`/`pttReleased`).
- **Microphone mute**: a keybind toggles `acre_sys_core_micMuted` (sent with `vox:mute` by the alive monitor, together with death and the mic test). It's published on our unit; the Players screen (`RscDisplayMPPlayers`, which has no `onLoad` of its own, so CBA's display events don't reach it) gets an `onLoad` that marks muted players' rows every 0.25 s, matched by name. A title shows our own state (movable in the layout editor).
- **Crypto**: rustls with `ring` only (no aws-lc, so no cmake/nasm for that). TLS 1.3 only.
- **Opus**: `opusic-c`. Dev builds link the system libopus; release builds enable `acre2_voice_codec/bundled` (static, needs cmake). The encoder is capped at super-wideband: fullband lets Opus switch to CELT on tonal input, and CELT packets carry no in-band FEC.
- **Audio threads**: device callbacks only touch lock-free `rtrb` rings. A `acre2-voice-tx` thread encodes 20 ms frames; `acre2-voice-mix` renders frames to keep ~60 ms queued ahead of the speakers (or self-clocks with no output device). Control/voice from the network go through a tokio task into the mixer.
- **Transmissions from a client**: `TxId(0)` is direct speech; keyed transmissions (radios etc.) use other ids chosen by the caller. A held key sends on its own tx *and* direct speech. Each talk spurt is a Start → frames (last with `END_OF_SPURT`) → Stop, so listeners get a fresh `TransmissionStarted` per spurt, like ACRE's `remoteStartSpeaking` today.

## Open questions

- **Q4 — Mission-less voice**: the briefing is covered (a `briefing` channel). The lobby (before a unit exists) isn't: players connect once they have a unit.
- **Q6 — Opus frame size**: 20 ms (robust) or 10 ms (lower latency, more overhead)? *Default: 20 ms, configurable.*
- **Q7 — Recording/admin tools**: should the server support admin mute, kick or recording hooks?
- **Q11 — Extension name**: the voice extension is `acre_voice_x64` because `acre_x64` is still the C++ signal extension. Merge them in Phase 7, or keep two?
- **Q12 — Positional sound**: X3DAudio's exact panning isn't public. The reimplementation follows its documented behaviour; does it sound right to people who know ACRE? (A listening test before release.)
- **Q13 — Radio subscription updates**: polled every 0.25 s from SQF. Fast enough, or should retuning push immediately via sys_data events?
- **Q9 — Audio outside Arma focus/alt-tab**: keep playing (TS3 behaviour)? *Default: yes.*

## Risks

- **DSP parity**: players know how ACRE radios sound. Golden tests against the C++ output are the mitigation.
- **Audio device edge cases on Windows** (exclusive mode, Bluetooth headsets, sample-rate changes): test early with a standalone CLI.
- **Arma main-thread cost**: the world feed and the `speaker:update` frequency must stay cheap. Batch them and profile with ACRE's counters.
- **Anti-cheat / BattlEye**: the extension now does networking and audio itself. The DLL must be whitelisted/signed as `acre_x64.dll` is today. Confirm early.
- **NAT/firewall**: one UDP port on the server, and clients connect out. Document the port.
