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

A local multiplayer host hosts voice like a dedicated server does: set *Public address* to `127.0.0.1`. To test without Arma, run `cargo run -p acre2_voice_server -- -c voice/server/acre2_voice_server.example.toml` in `rust/` and join it with `cargo run -p acre2_voice_testkit --features devices --bin acre2_voice_cli -- talk …` (see `rust/README.md`).

**Logs**

The voice extension logs to `%LOCALAPPDATA%\Arma 3\acre2_ext.log` (set `ACRE2_LOG=debug` for more).
