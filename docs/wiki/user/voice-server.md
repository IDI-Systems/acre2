---
title: Voice Server
---

ACRE2 carries voice through its own voice server instead of TeamSpeak. Each Arma server that runs ACRE2 needs one. It's a single small program, and it's included in the release download (`@acre2/server`).

## How it fits together

```
 players (Arma + ACRE2) ──UDP 9987──► voice server ◄── Arma server (ACRE2)
```

- The **voice server** routes voice: direct speech to players close enough to hear it, radio traffic to players with a radio on that channel. Everything is encrypted.
- The **Arma server** tells the voice server where everyone is, and hands each player a one-time ticket to join. Only players on your Arma server can join your voice server.
- **Players** connect automatically. They need outgoing UDP to the voice server's port; nothing on their side needs configuring.

## Setup

The voice server can run on the same machine as the Arma server (simplest) or anywhere else.

### 1. Run the voice server

1. Copy `acre2_voice_server(.exe)` and `acre2_voice_server.example.toml` from `@acre2/server` to a folder of your choice. (Linux builds are on the [releases page](https://github.com/IDI-Systems/acre2/releases).)
2. Rename the example to `acre2_voice_server.toml` and set at least `authority_secret` to a long random string.
3. If players should reach it under a different address than the Arma server uses (for example a domain name), set `public_address = "voice.example.com:9987"`.
4. Open **UDP port 9987** (or your `bind` port) in the firewall.
5. Start `acre2_voice_server`. It prints its certificate fingerprint and writes it to `data/fingerprint.txt`.

Keep it running while the Arma server is up (a service, `systemd` unit or scheduled task works well). It can stay up across missions and Arma restarts.

### 2. Point the Arma server at it

1. Copy `acre2_voice.example.toml` from `@acre2/server` into the Arma server's folder (next to `arma3server`) as `acre2_voice.toml`. Or put it anywhere and set the `ACRE2_VOICE_CONFIG` environment variable to its path.
2. Set `address` to where the Arma server reaches the voice server (`127.0.0.1:9987` on the same machine), and `secret` to the same `authority_secret`.
3. Recommended: set `fingerprint` to the contents of `data/fingerprint.txt`.
4. If `address` isn't reachable by players (e.g. `127.0.0.1`) and you didn't set `public_address` on the voice server, set `client_address` here.

The secret only lives in these two files. It never passes through missions, CBA settings or players.

### 3. Check

Start the mission. The Arma server's RPT log shows `Connected to the voice server. Players will connect to …`, and players get an *ACRE connected* notification. If not, the RPT says why (missing config, wrong secret, unreachable address).

## Reference

`acre2_voice_server.toml`:

| Key | Default | |
|---|---|---|
| `bind` | `0.0.0.0:9987` | UDP address to listen on |
| `public_address` | | Address players connect to |
| `authority_secret` | (required) | Shared secret for the Arma server, at least 8 characters |
| `data_dir` | `data` | Where the certificate is kept |
| `token_ttl` | `120` | Seconds a join ticket stays valid |
| `reresolve_interval` | `200` | Milliseconds between re-routing as players move |
| `max_spatial_range` | `300` | Furthest direct speech is sent, metres |
| `max_extra_positions` | `4` | Camera positions a Zeus/spectator may report |
| `max_peers` | `512` | Most players at once |

Set `RUST_LOG=debug` for verbose logs.

Bandwidth is roughly 25 kbit/s per speaker per listener while they talk, nothing while silent.
