# ACRE without TeamSpeak — Plan

Living document. Update the checkboxes and the **Decisions** / **Open questions** sections as work progresses.

## Goals

1. **Voice library**: a general-purpose game voice chat library in Rust, with a server and a client. Opus codec tuned for game chat. The server knows where players are (for local/direct voice) and which channels (radio frequencies etc.) they're on, and only forwards audio to clients that can hear it.
2. **New ACRE extension**: a Rust extension built on that library and [arma-rs](https://github.com/BrettMayson/arma-rs). It replaces the TS3 plugin, the named pipe and the string-splitting RPC with typed `callExtension` arguments and extension callbacks.

## Decisions (made)

| # | Decision | Notes |
|---|----------|-------|
| D1 | **Standalone voice server, fed by Arma** | A standalone Rust binary (the server is also a library crate). The Arma dedicated server's ACRE extension connects to it as a trusted *authority*: it pushes player positions/state and issues join tokens. Clients can only join with a token handed to them by the mission. |
| D2 | **Scope: pipe + DSP now, signal later** | Replace `ACRE2Arma/arma2ts` (pipe), `ACRE2Core` (TS plugin DSP) and drop `ACRE2Steam` and `ACRE2TS`. Keep `acre.dll` (signal/terrain/antenna, `fnc_callExt`) unchanged for now and port it in a later phase. |
| D3 | **Hard cut from TS3** | No backend abstraction. TS3 users stay on the last 2.x release. |
| D4 | **Cargo workspace in `rust/`** | A separate `rust/` directory keeps it apart from the C++ in `extensions/`. Crates use the `acre2_` prefix. The voice library crates stay free of ACRE/Arma code so they could be split out later. |
| D5 | **Windows x64 client, Windows + Linux x64 server** | Arma 3 is 64-bit only, so drop the 32-bit DLLs. Dedicated servers on Linux need the server-side extension `.so` and the voice server binary. |
| D6 | **Direct speech: voice activation by default, push-to-talk optional** | CBA settings: activation mode (voice activation / push-to-talk) and voice-activation sensitivity (threshold, with a live mic level meter if feasible). A CBA keybind for direct push-to-talk. The extension does the activation detection; SQF only sets the mode, threshold and key state. |
| D7 | **Clients report their radio rx subscriptions** | This is only a bandwidth optimisation (a modded client can eavesdrop on any radio anyway), and the server SQF doesn't have cheap access to every player's tuned radios. Positions and identity still come from the authority. |
| D8 | **Clients can report extra positions when the authority allows it** | Zeus (camera comms) and spectators speak or listen from the camera, which only the client knows. Today the Zeus client already broadcasts `zeusPosition` = `[getPosASL curatorCamera, getCameraViewDirection curatorCamera]` as a public variable every 0.2 s ([sys_zeus/fnc_handleZeusSpeakPress.sqf](addons/sys_zeus/fnc_handleZeusSpeakPress.sqf)). The library supports this generically: a peer has an authority position plus client-reported *extra positions* (`emitter` and/or `listener`). The client may report them only while the authority has granted that peer the matching permission (e.g. while it's a curator or spectator). See "Positions" below. |
| D9 | **Any PTT always opens the mic** | Holding any push-to-talk key (direct PTT, radio PTT, intercom, Zeus, god mode) transmits regardless of the voice-activation threshold. Direct speech is also sent while a radio PTT is held, as today. Voice activation only gates direct speech when no PTT is held. |

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

## Target architecture

```
                         ┌──────────────── Voice Server (standalone bin) ────────────────┐
                         │ sessions · world state · channel subscriptions · router         │
                         └──▲──────────────────────────▲─────────────────────────▲─────────┘
           authority link   │ QUIC (reliable)          │ QUIC: control stream    │
           (shared secret)  │                          │ + datagrams (Opus)      │
                            │                          │                         │
 Arma dedicated server ─────┘            Arma client A ┘           Arma client B ┘
  acre_x64.so/.dll (server mode)          acre_x64.dll (client mode)
  · pushes positions @ ~10 Hz             · mic capture → VAD/PTT → Opus → send
  · issues join tokens                    · recv → jitter buffer → decode → ACRE DSP → mixer → out
  · sends token/addr/cert to clients      · SQF ⇄ ext via typed args + ExtensionCallback
    via remoteExec
```

### Workspace layout (proposed)

```
rust/
  Cargo.toml           workspace
  voice/
    proto/             acre2_voice_proto    wire types, framing, versioning (no I/O)
    codec/             acre2_voice_codec    Opus wrapper, FEC/DTX config, jitter buffer, PLC
    server/            acre2_voice_server   lib: sessions, world state, routing; + bin `acre2_voice_server`
    client/            acre2_voice_client   lib: connection, capture/playback (cpal), activation, send/recv pipeline, mixer hooks
    testkit/           acre2_voice_testkit  headless bots (play wav, record), loss/latency simulator
  acre/
    dsp/               acre2_dsp            port of ACRE2Core effects (positional, radio, babel, volume, occlusion, pink noise)
    ext/               acre2_ext            cdylib built as `acre_x64` (arma-rs): client mode + server/authority mode
```

The existing C++ stays where it is until Phase 6 removes it.

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
- **Certificates**: the server generates a self-signed cert on first run. Its SHA-256 fingerprint travels with the join token: voice server → authority → Arma server → `remoteExec` → client. The client pins it, so the trust chain is Arma's own network.
- **Join flow**:
  1. Arma server ext (authority) connects to the voice server with a shared secret from config.
  2. When a player joins the mission, the server ext requests a token for their UID. The voice server returns `{token, addr, fingerprint}`.
  3. The server `remoteExec`s that to the client. The client ext connects and presents the token, which is single-use and has a short TTL.
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
| Radio TX on radio X | Channel target `radio:<freq>` (or `radio:<freq>:<modulation>`) plus metadata `{radioId, languageId, curveScale, netId}` |
| Radio RX | The client subscribes to the channels of all radios it has powered on and tuned, and re-syncs when radios change |
| Intercom (`i`) | Channel `intercom:<vehicleNetId>:<intercomId>` |
| Zeus (`z`) | Spatial target. The client reports the curator camera as its `emitter` and `listener` extra position (D8). The authority grants `report_position` while the player is a curator. Listeners keep the current emitter-position DSP logic, which reads `zeusPosition`. That variable broadcast can later be replaced by the position sent in the transmission. |
| God mode (`g`) | Channel `god:<group>` with an authority permission gate |
| Spectator (`s`) | Channel `spectator`. The spectator camera is reported as a `listener` extra position (D8) where spatial hearing applies |
| Babel/languages | Metadata `languageId`. The listener applies the babel effect as today |
| Signal quality, radio distortion | Still listener-side: SQF + `acre.dll` compute it and pass it to the DSP via `speaking:update` (same as today) |
| `remoteStartSpeaking` / `remoteStopSpeaking` | Fired from the ext as `ExtensionCallback` on TransmissionStart/End |

The server-side routing for radio is **frequency only** (no distance cut). The listener decides audibility and quality, as today. Direct speech gets a distance cut, which is where the bandwidth savings are.

### New extension API (arma-rs)

Typed args with arma-rs `FromArma`/`IntoArma` (derive where possible). Commands are grouped. Events arrive through `ExtensionCallback` (`"acre"`, `<event>`, `<data>`), which **replaces the per-frame `sys_io` polling**.

Client mode (sketch, final names TBD in Phase 4):

```
acre callExtension ["voice:connect",   [addr, token, fingerprint]]
acre callExtension ["voice:disconnect",[]]
acre callExtension ["self:update",     [[listenerPosASL...], [listenerDir...], languageId]]   // replaces updateSelf/setHeadVector (local DSP only)
acre callExtension ["self:positions",  [[[posASL...], [dir...], "emitter"|"listener"|"both"], ...]]  // D8 extra positions (Zeus/spectator cam); [] clears
acre callExtension ["vox:settings",    [mode, threshold]]    // mode: "vad"|"ptt"; threshold in dBFS
acre callExtension ["vox:ptt",         [pressed]]            // direct-speech PTT key state (when mode == "ptt")
acre callExtension ["tx:start",        [kind, radioId|"", channelKey|"", languageId, curveScale]]
acre callExtension ["tx:stop",         [kind, radioId|""]]
acre callExtension ["rx:subscriptions",[["radio:43.100", ...]]]
acre callExtension ["speaker:update",  [peerId, kind, babel, volume, [pos], [dir], <radio params...>]]   // replaces updateSpeakingData
acre callExtension ["speaker:mute",    [peerId, bool]]
acre callExtension ["sound:load",      [id, base64|path]]
acre callExtension ["sound:play",      [id, [pos], volume, isWorld]]
acre callExtension ["settings:set",    [key, value]]                                    // incl. voice curve model, master override
acre callExtension ["audio:devices",   []]   → [[inputs...],[outputs...]]
acre callExtension ["audio:select",    [inputId, outputId]]
acre callExtension ["version",         []]
```

Callbacks: `connected`, `disconnected(reason)`, `mic_level(dBFS)` (only while the settings UI is open), `remote_start(peerId, netId, kind, radioId, languageId, curveScale, targets)`, `remote_stop(peerId, kind, radioId)`, `local_start/local_stop`, `sound_loaded(id)`, `stats(...)`.

Server/authority mode (only on a dedicated or hosted server):

```
acre callExtension ["authority:start",   [addr, secret]]
acre callExtension ["authority:token",   [uid, netId]]         → async callback with {token, addr, fingerprint}
acre callExtension ["authority:world",   [[[uid, [pos], alive, flags], ...]]]   // batched, ~10 Hz from a PFH
acre callExtension ["authority:perm",    [uid, channelPrefix, allowTx, allowRx]]
acre callExtension ["authority:report_position", [uid, allowed]]   // D8: grant/revoke while curator/spectator
```

Batching `authority:world` stays within `callExtension`'s 2048-arg limit. Chunk the call if a mission is larger than that.

## Phases

### Phase 0 — Scaffolding
- [x] Cargo workspace + crates as above, `rust-toolchain.toml`, clippy/fmt config
- [x] CI: [.github/workflows/rust.yml](.github/workflows/rust.yml) runs fmt, clippy (`-D warnings`) and tests, then builds `acre_x64.dll` + `acre2_voice_server.exe` (Windows MSVC) and `acre_x64.so` + `acre2_voice_server` (Linux) as artifacts
- [ ] Hook the Rust artifacts into [tools/make.py](tools/make.py) / [release.yml](.github/workflows/release.yml) (when the ext replaces the C++ in Phase 4–6)
- [x] Decide crate names and location (D4: `rust/`, `acre2_` prefix)

### Phase 1 — Voice library core
- [x] `proto`: control messages, datagram format, framing, protocol version handshake
- [x] `server`: QUIC endpoint, authority link, token issuing, sessions, world state, subscriptions, router (spatial + channel), periodic re-resolve, channel rules
- [x] `server`: extra positions (D8): permission gate, multiple listener positions, emitter override
- [ ] `server`: rate-limit extra-position reports and voice datagrams per peer; optional sanity clamp on reported positions
- [x] `server` bin: TOML config ([example](rust/voice/server/acre2_voice_server.example.toml)), logging (`RUST_LOG`), cert persistence + `fingerprint.txt`
- [x] `client`: connect with token + fingerprint pin, control stream, datagram send/recv; `Authority` with `issue_token`/`ping`/world/rules
- [ ] `client`: reconnect/backoff (needs a fresh token from the authority, so it belongs partly to the ext)
- [ ] `codec`: Opus encode/decode, jitter buffer, FEC/PLC, loss stats
- [x] `testkit`: in-process harness (server + authority + bots) and 13 end-to-end tests over real QUIC (routing, rules, Zeus camera, tokens, kicks, pinning)
- [ ] `testkit`: bots that play wav clips and record what they hear; latency/loss assertions with a network simulator
- [ ] Load test: 100+ peers, 20+ concurrent speakers, measure server CPU and bandwidth

### Phase 2 — Client audio
- [ ] `cpal` capture/playback, device enumeration and selection, hot-plug handling
- [ ] Resampling, optional noise suppression and AGC
- [ ] Activation (D6): voice activation with an adjustable threshold, hangover/attack times and a mic level meter; PTT gate; voice activation is the default
- [ ] Mixer: per-speaker channels, local sounds, master volume/override
- [ ] Standalone test app (CLI) that joins a server and talks, for testing without Arma

### Phase 3 — ACRE DSP port (`acre/dsp`)
- [ ] Inventory of [ACRE2Core](extensions/src/ACRE2Core) effects: `PositionalMixdownEffect`, `RadioEffect`/`FilterRadio`, `BabelFilter`, `VolumeEffect`, `FilterOcclusion`, `FilterPosition`, `FilterGain`, `AmplitudeAttenuation`, `PinkNoise`, `DspFilters` (Butterworth etc.)
- [ ] Port each effect and parameter. Golden tests: render the same wav and params through the C++ and the Rust code, then compare (by tolerance or spectrum)
- [ ] Voice curve models (`setVoiceCurveModel`, selectable curve scale)
- [ ] Positional/HRTF behaviour parity (same speaker-position and head-vector math)

### Phase 4 — ACRE extension (`acre/ext`)
- [ ] arma-rs client mode: commands above, `FromArma` structs, `ExtensionCallback` events
- [ ] Authority mode: link to the voice server, token issuing, world feed
- [ ] Map every RPC in the inventory to a new command or callback, or mark it as removed
- [ ] Logging to the ACRE log dir. Errors are reported to SQF via callback, not swallowed
- [ ] Ext unit tests via the arma-rs test harness

### Phase 5 — SQF migration
- [ ] Rewrite `sys_io` / `sys_rpc`: remove the pipe and polling, add an `ExtensionCallback` handler, and a thin `FUNC(ext)` wrapper
- [ ] Server side: start the authority, a PFH world feed, and token issue on `PlayerConnected` → `remoteExec` to the client; handle respawn and team switch
- [ ] Replace all `callRemoteProcedure` call sites (see the list in the RPC inventory)
- [ ] Rx subscription sync whenever radio power, frequency or channel changes (hook the existing sys_data/sys_radio events)
- [ ] Replace the TS3 IDs (`GET_TS3ID`, client ID loops) with voice `peerId` / UID
- [ ] Remove TS-specific features: `ts3ChannelMove`, VOIP channel/server name/UID, the Steam plugin installer (`steam_boot.sqf`), and the "Plugin not found" check. Add a "voice server not reachable" UX instead
- [ ] D6: CBA settings for activation mode (default voice activation) and sensitivity, a direct-speech PTT keybind, device selection, and a mic test/level meter
- [ ] D8: Zeus/spectator cameras → `self:positions`; the server grants `authority:report_position` on curator/spectator enter and exit
- [ ] Zeus, spectator, god mode, intercom and babel parity checks

### Phase 6 — Cleanup & release
- [ ] Remove `ACRE2Arma/arma2ts`, `ACRE2Core`, `ACRE2TS`, `ACRE2DistortionTestPlugin`, `ACRE2Steam`, and the 32-bit DLLs
- [ ] Docs: server setup (voice server bin, config, ports, secret), player setup (devices), migration notes
- [ ] Packaging: voice server binaries in releases; optionally a Docker image
- [ ] Playtests with real groups at increasing size

### Phase 7 — Later
- [ ] Port `acre.dll` (signal, antenna, terrain/WRP loading, signal map) to Rust inside the same extension, and drop `acre_dynload`
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
- **Crypto**: rustls with `ring` only (no aws-lc, so no cmake/nasm for that). TLS 1.3 only.

## Open questions

- **Q4 — Mission-less voice**: should players be able to talk in the lobby or briefing before they have a unit? (Perhaps a `lobby` channel with no spatial routing.)
- **Q5 — Voice server deployment**: should we also offer "spawn `acre2_voice_server` as a child process of the Arma server" as a convenience, alongside running it standalone?
- **Q6 — Opus frame size**: 20 ms (robust) or 10 ms (lower latency, more overhead)? *Default: 20 ms, configurable.*
- **Q7 — Recording/admin tools**: should the server support admin mute, kick or recording hooks?
- **Q9 — Audio outside Arma focus/alt-tab**: keep playing (TS3 behaviour)? *Default: yes.*

## Risks

- **DSP parity**: players know how ACRE radios sound. Golden tests against the C++ output are the mitigation.
- **Audio device edge cases on Windows** (exclusive mode, Bluetooth headsets, sample-rate changes): test early with a standalone CLI.
- **Arma main-thread cost**: the world feed and the `speaker:update` frequency must stay cheap. Batch them and profile with ACRE's counters.
- **Anti-cheat / BattlEye**: the extension now does networking and audio itself. The DLL must be whitelisted/signed as `acre_x64.dll` is today. Confirm early.
- **NAT/firewall**: one UDP port on the server, and clients connect out. Document the port.
