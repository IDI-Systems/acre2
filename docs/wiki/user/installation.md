---
title: Installation
---

{% include tip.html content="Steam or community-provided installation methods are recommended over manual setup for ease of use." %}

ACRE2 carries voice itself: there is no TeamSpeak or other voice program to install. Servers run a small voice server alongside Arma (see [Voice Server](/wiki/user/voice-server)); players just join.

### Steam

- Subscribe to [ACRE2 on Steam](http://steamcommunity.com/sharedfiles/filedetails/?id=751965892) (make sure you are also subscribed to [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)).
- Launch Arma 3 and join a server running ACRE2.

### Manual

- Download from the [latest version](https://github.com/IDI-Systems/acre2/releases/latest) and extract the `.zip` file to your hard drive.
- Navigate to your Arma 3 installation folder.
- Delete any current `@acre2` folder and then paste in the `@acre2` folder you from the extracted `.zip`.
- Load it with the Arma 3 Launcher (Mods → add a local mod → select `@acre2`) or add `@acre2` and `@CBA_A3` to the `-mod` parameter of a shortcut.


### Microphone and speakers

ACRE2 uses your system's default microphone and output device. Everything is in the in-game addon options (`Options → Addon Options → ACRE2`):

- **Direct speech activation**: *Voice activation* (default) or *Push to talk*. With push to talk, bind the *Direct Speech PTT* key under `Options → Controls → Configure Addons → ACRE2`. Radio, intercom, Zeus and god mode PTT keys always transmit, whatever this is set to.
- **Voice activation sensitivity**: the microphone level (dB) that starts direct speech. Lower is more sensitive; raise it if background noise keeps you transmitting.
- **Microphone** / **Speakers / headphones**: a device id to use instead of the system default. Run `call acre_api_fnc_getAudioDevices` in the debug console to list ids. Leave empty for the default.


### Configuration

You can configure ACRE2 features to your needs. ACRE2 uses the [CBA Settings System](https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System), accessible via the in-game configuration. This applies to [server](https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System#server-settings), mission and client settings.

Server administrators can get available settings using the [export/import features](https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System#export-and-import-function). The options then need to go into [CBA's userconfig or an addon](https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System#userconfig). Server settings can be configured to override specific mission settings.


### Troubleshooting

- **WARNING: ACRE IS NOT CONNECTED TO THE VOICE SERVER!**  
The server isn't connected to its voice server, or your firewall blocks it. ACRE2 retries on its own. If it persists, let your server administrator know (the server's RPT log says why), and check that outgoing UDP to the voice server's port (default 9987) is allowed.

- **Nobody hears me / I transmit all the time**  
Check *Voice activation sensitivity*, or switch *Direct speech activation* to *Push to talk*. Make sure Windows uses the microphone you expect, or set *Microphone* explicitly.

- **Radio beeps not audible on dedicated server**  
Make sure your `server.cfg` has `"b64"` whitelisted in `allowedLoadFileExtensions[]` and `allowedPreprocessFileExtensions[]` if you are using that. Let your server administrator know if you have no idea what this means.
