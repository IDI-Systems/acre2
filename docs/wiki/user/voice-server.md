---
title: Voice Server
---

ACRE2 carries voice itself instead of using TeamSpeak. The Arma server hosts the voice server: there is nothing extra to install or run.

## How it fits together

```
 players (Arma + ACRE2) ──UDP 9987──► Arma server (ACRE2, hosting voice)
```

- The server routes voice: direct speech to players close enough to hear it, radio traffic to players with a radio on that channel. Everything is encrypted.
- Only players on your Arma server can join it; each gets a one-time ticket from the server when they join.
- Players connect automatically. They need outgoing UDP to the voice port; nothing on their side needs configuring.

## Setup

1. In the addon options (`Options → Addon Options → ACRE2 Voice Server`, server settings), set:
   - **Public address**: the IP or hostname players reach this server at, e.g. `203.0.113.10` or `arma.example.com`. Required.
   - **Voice port (UDP)**: `9987` by default.
2. Open that **UDP** port in the server's firewall (and forward it on your router if the server is behind one).
3. Start the mission. The RPT log shows `Connected to the voice server. Players will connect to …`, and players get an *ACRE connected* notification.

Settings can also go in [CBA's server settings file](https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System#userconfig):

```sqf
force acre_sys_server_voiceAddress = "arma.example.com";
force acre_sys_server_voicePort = "9987";
```

Or as environment variables for the Arma server process, which take priority: `ACRE2_VOICE_ADDRESS` and `ACRE2_VOICE_PORT`.

Changing either needs a mission restart.

## Troubleshooting

- **RPT: `no voice server address set`**: set *Public address*.
- **RPT: `starting the voice server on UDP …`**: the port is in use (another Arma server on this machine? give each its own port) or not allowed.
- **Players see *not connected to the voice server***: the port isn't reachable from outside (firewall, router), or *Public address* is wrong.

Bandwidth is roughly 25 kbit/s per speaker per listener while they talk, nothing while silent. Logs: `acre2_ext.log` (set `ACRE2_LOG=debug` for more).
