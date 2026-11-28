# ACRE Rust workspace

ACRE's voice: a game-agnostic voice library and the Arma extension built on it, replacing the TeamSpeak 3 plugin. See [../plan.md](../plan.md) for the design, decisions and status, and [the voice server docs](../docs/wiki/user/voice-server.md) for setup.

| Crate | Path | |
|---|---|---|
| `acre2_voice_proto` | `voice/proto` | Wire protocol: control messages, voice datagrams, framing |
| `acre2_voice_net` | `voice/net` | QUIC endpoint setup with a plain-UDP fallback (Wine/Proton). `cargo run -p acre2_voice_net --example socket_probe` shows which path a platform uses |
| `acre2_voice_server` | `voice/server` | Voice server: sessions, routing (spatial + channels), tokens, rate limits. Also a standalone `acre2_voice_server` binary for testing |
| `acre2_voice_client` | `voice/client` | Player connection (`Client`), game-server connection (`Authority`), and the audio pipeline (`audio`; live devices with the `devices` feature) |
| `acre2_voice_codec` | `voice/codec` | Opus encoding/decoding, adaptive jitter buffer, FEC/PLC |
| `acre2_voice_testkit` | `voice/testkit` | Test harness, end-to-end/audio/load tests, `acre2_voice_cli` |
| `acre2_dsp` | `acre/dsp` | ACRE's radio, babel, volume and positional effects (golden-tested against the original C++) |
| `acre2_ext` | `acre/ext` | The Arma extension `acre_voice_x64.dll` / `.so`: player voice client, and on the server the hosted voice server + authority |

The `voice/*` crates know nothing about ACRE or Arma.

## Building and testing

To build both release binaries on Linux and copy them to the repo root for `hemtt release`, run `./build-extension.sh` from the repo root (`windows` or `linux` to build just one).

Linux needs the ALSA and libopus development packages (`libasound2-dev libopus-dev`). Release builds compile libopus in instead (`--features acre2_voice_codec/bundled`, needs CMake).

```sh
cargo test --workspace --features acre2_voice_testkit/devices
cargo clippy --workspace --all-targets --features acre2_voice_testkit/devices
cargo build --release -p acre2_ext --features acre2_voice_codec/bundled   # → acre_voice.dll, ship as acre_voice_x64.dll
cargo build --release -p acre2_ext --no-default-features                 # Linux dedicated server, no audio devices

RUST_LOG=debug cargo test -p acre2_voice_testkit                            # with logs
cargo test --release -p acre2_voice_testkit --test load -- --ignored --nocapture
acre/dsp/reference/generate.sh                                              # regenerate DSP golden files (needs g++)
```

## Trying voice without Arma

```sh
cargo run -p acre2_voice_server -- -c voice/server/acre2_voice_server.example.toml
cargo run -p acre2_voice_testkit --features devices --bin acre2_voice_cli -- devices
cargo run -p acre2_voice_testkit --features devices --bin acre2_voice_cli -- \
    talk --server 127.0.0.1:9987 --secret 'change me please' --name alice
```

Run a second `talk` with another `--name` and `--pos 10,0,0` to hear each other (`--ptt` for push-to-talk, `--radio radio:1` to also talk on a channel).
