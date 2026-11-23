# ACRE Rust workspace

Replacement for the TeamSpeak 3 plugin and the C++ extensions. See [../plan.md](../plan.md) for the plan and status.

| Crate | Path | |
|---|---|---|
| `acre2_voice_proto` | `voice/proto` | Wire protocol: control messages, voice datagrams, framing |
| `acre2_voice_server` | `voice/server` | Voice server library + `acre2_voice_server` binary |
| `acre2_voice_client` | `voice/client` | Player connection (`Client`) and game-server connection (`Authority`) |
| `acre2_voice_codec` | `voice/codec` | Opus, jitter buffer (not yet implemented) |
| `acre2_voice_testkit` | `voice/testkit` | Test harness and end-to-end tests |
| `acre2_dsp` | `acre/dsp` | ACRE radio/positional effects (not yet implemented) |
| `acre2_ext` | `acre/ext` | Arma extension, built as `acre_x64.dll` / `acre_x64.so` |

The `voice/*` crates know nothing about ACRE or Arma.

```sh
cargo test --workspace
cargo clippy --workspace --all-targets
cargo run -p acre2_voice_server -- -c voice/server/acre2_voice_server.example.toml
RUST_LOG=debug cargo test -p acre2_voice_testkit   # with logs
```
