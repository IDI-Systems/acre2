---
title: Tips and Tricks
---

This page lists various development methods for easier testing and debugging.


## Arma 3

### Signal

Reference [Radio Signal Debugging](/wiki/frameworks/radio-signal-debugging) page.


## Extensions

### Voice

**Local voice server**

Run `cargo run -p acre2_voice_server -- -c voice/server/acre2_voice_server.example.toml` in `rust/` and point a local `acre2_voice.toml` at it. `cargo run -p acre2_voice_testkit --features devices --bin acre2_voice_cli -- talk …` joins it from the command line, without Arma (see `rust/README.md`).

**Logs**

The voice extension logs to `%LOCALAPPDATA%\Arma 3\acre2_ext.log` (set `ACRE2_LOG=debug` for more). The voice server logs to its console (`RUST_LOG=debug`).
