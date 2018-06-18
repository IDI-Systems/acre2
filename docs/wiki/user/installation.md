---
title: Installation
---

### Manual

- Download from the [latest version](https://github.com/IDI-Systems/acre2/releases/latest) and extract the `.zip` file to your hard drive.
- Navigate to your Arma 3 installation folder.
- Delete any current `@acre2` folder and then paste in the `@acre2` folder you from the extracted `.zip`.
- Create a new shortcut or edit an existing one, and add `@acre2` and `@CBA_A3` to the `-mod` parameter (for a longer explanation see [this tutorial](http://www.armaholic.com/forums.php?m=posts&q=20866))
- Launch Arma 3 from the shortcut you created.
- ACRE2 will try to copy the plugins to your TeamSpeak 3 installation directory. A pop-up will appear describing what the process did.
- Launch TeamSpeak 3 and enable the ACRE2 plugin in the `Settings -> Plugins` window.


### Steam

- Subscribe to [ACRE2 on Steam](http://steamcommunity.com/sharedfiles/filedetails/?id=751965892) (make sure you are also subscribed to [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)).
- Launch Arma 3.
- ACRE2 will try to copy the plugins to your TeamSpeak 3 installation directory. A pop-up will appear describing what the process did.
- Launch TeamSpeak 3 and enable the ACRE2 plugin in the `Settings -> Plugins` window.

### Troubleshooting

- **WARNING: ACRE IS NOT CONNECTED TO TEAMSPEAK!**  
Make sure to launch both Arma 3 (Steam) and TeamSpeak 3 as admin, or neither.

- **Radio beeps not audible on dedicated server**  
Make sure your `server.cfg` has `"b64"` whitelisted in `allowedLoadFileExtensions[]` and `allowedPreprocessFileExtensions[]` if you are using that. Let your server administrator know if you have no idea what this means.

- **Insufficient client permissions `(failed on i_channel_needed_subscribe_power)`**
This does not affect ACRE2's functionalities. The ACRE2 TeamSpeak plugin will subscribe to all channels in the TeamSpeak server, and if the TeamSpeak server contains any channels which have a higher `i_channel_needed_subscribe_power` value than what the client is granted then TeamSpeak will throw an error.
