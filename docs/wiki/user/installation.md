---
title: Installation
---

{% include tip.html content="Steam or community-provided installation methods are recommended over manual setup for ease of use." %}

### Steam

- Subscribe to [ACRE2 on Steam](http://steamcommunity.com/sharedfiles/filedetails/?id=751965892) (make sure you are also subscribed to [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)).
- Launch Arma 3.
- ACRE2 will try to copy the plugins to your Mumble/TeamSpeak 3 installation directory. A pop-up will appear describing what the process did.
- Launch Mumble/TeamSpeak 3 and assure the ACRE2 plugin is enabled in the `Settings -> Plugins` window.


### Manual

- Download from the [latest version](https://github.com/IDI-Systems/acre2/releases/latest) and extract the `.zip` file to your hard drive.
- Navigate to your Arma 3 installation folder.
- Delete any current `@acre2` folder and then paste in the `@acre2` folder you from the extracted `.zip`.
- _Proceed with Arma 3 Launcher or a manual Shortcut creation._

#### Arma 3 Launcher

- Launch the Arma 3 Launcher, go the the Mods menu, and click to add a local mod.
- In the dialogue that appears, navigate to your Arma 3 installation folder and select the `@acre2` folder.
- Enable the mod.
- Launch Arma 3 in the Launcher.
- ACRE2 will try to copy the plugins to your Mumble/TeamSpeak 3 installation directory. A pop-up will appear describing what the process did.
- Launch Mumble/TeamSpeak 3 and assure the ACRE2 plugin is enabled in the `Settings -> Plugins` window.

#### Shortcut

- Create a new shortcut for Arma 3, or edit an existing one, and add `@acre2` and `@CBA_A3` to the `-mod` parameter.
- Launch Arma 3 through the shortcut you created.
- ACRE2 will try to copy the plugins to your Mumble/TeamSpeak 3 installation directory. A pop-up will appear describing what the process did.
- Launch Mumble/TeamSpeak 3 and assure the ACRE2 plugin is enabled in the `Settings -> Plugins` window.


### Configuration

You can configure ACRE2 features to your needs. ACRE2 uses the [CBA Settings System](https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System), accessible via the in-game configuration. This applies to [server](https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System#server-settings), mission and client settings.

Server administrators can get available settings using the [export/import features](https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System#export-and-import-function). The options then need to go into [CBA's userconfig or an addon](https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System#userconfig). Server settings can be configured to override specific mission settings.


### Troubleshooting

- **WARNING: ACRE is not connected to Mumble/TeamSpeak!**  
Make sure to launch both Arma 3 (Steam) and Mumble/TeamSpeak 3 as admin, or neither.

- **Radio beeps not audible on dedicated server**  
Make sure your `server.cfg` has `"b64"` whitelisted in `allowedLoadFileExtensions[]` and `allowedPreprocessFileExtensions[]` if you are using that. Let your server administrator know if you have no idea what this means.

- **Insufficient client permissions `(failed on i_channel_needed_subscribe_power)`**
This does not affect ACRE2's functionalities. The ACRE2 TeamSpeak plugin will subscribe to all channels in the TeamSpeak server, and if the TeamSpeak server contains any channels which have a higher `i_channel_needed_subscribe_power` value than what the client is granted then TeamSpeak will throw an error.
