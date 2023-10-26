---
title: TeamSpeak Channel Switching
---

## Setup

ACRE2 includes the option to automatically switch to a dedicated TeamSpeak 3 channel upon game start. This is enabled by default and can be turned off. Players are moved when the game starts, after the briefing (upon pressing "Continue"). This feature can be disabled in the addon settings.

Dedicated TS3 channels need to be created for this to function. Channel names must contain "ACRE" to be detected as a dedicated channel, unless a specific TS3 channel name is set in the settings.

Channel names can contain all or part of the Arma 3 server name. If this is the case, the best matching channel name will be selected to switch to. This allows for multiple ACRE dedicated channels to be active at once for multiple Arma servers.

It is also possible to set the name of the desired TS3 channel in the addon settings. When this is filled in, the best matching TS3 channel will be used. When empty, the Arma 3 server name will be used as above. When specifying a channel name to use, a password for the channel may also be specified. This will only be used if the specified channel can be found.

Note: The name matching is considered fuzzy, meaning it will not always provide the exact result that may be expected.

{% include warning.html content="Ensure the Arma 3 Server Name does **not contain any non-ASCII characters** e.g. `ä`, `á`, `à`, `â`. ACRE will currently not be able to connect to the TeamSpeak Server in that case." %}

### Example

 - A default TS3 channel: "ACRE"
 - Server specific channel(s): "ACRE - My Community's Server", "ACRE: PVP"
 - Arma 3 server name(s): "My Community's Server", "PVP Session", "Private Coop Session"

In the above scenario:
 - Players joining "My Community's Server" will be moved to "ACRE - My Community's Server"
 - Players joining "PVP Session" will be moved to "ACRE: PVP"
 - Players joining "Private Coop Session" will be moved to "ACRE"

## Settings

Located in CBA settings for the 'ACRE2' addon.

##### TeamSpeak Channel Switch

- Enables/Disables automatic TeamSpeak channel switching
- Default: `true`

##### TeamSpeak Channel Name

- Sets the name of the TeamSpeak channel to switch to
- Default: `""`
- When empty, the name of the server will be used when finding a TeamSpeak channel

##### TeamSpeak Channel Password

- Sets the password for the TeamSpeak channel name to switch to specified above
- Default: `""`
- This will only be used if the specified TeamSpeak channel is found
