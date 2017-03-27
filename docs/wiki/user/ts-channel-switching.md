---
title: TeamSpeak 3 Channel Switching
---

ACRE2 includes the option to automatically switch to a dedicated TeamSpeak 3 channel upon game start. This is enabled by default and can be turned off with CBA settings. Players are moved when the game starts, after the briefing (upon pressing "Continue").

Dedicated TS3 channels need to be created for this to function. Channel names must contain "ACRE" to be detected as a dedicated channel. 
Channel names can contain all of or part of the Arma 3 server name. If this is the case, the best matching channel name will be selected to switch to. This allows for multiple ACRE dedicated channels to be active at once.

An example setup is as follows:
 - A default TS3 channel: "ACRE"
 - Server specific channel(s): "ACRE - My Community's Server", "ACRE: PVP"
 - Arma 3 server name(s): "My Community's Server", "PVP Session", "Private Coop Session"
In this example, players joining "My Community's Server" will be moved to "ACRE - My Community's Server", players joining "PVP Session" will be moved to "ACRE: PVP", and players joining "Private Coop Session" wil be moved to "ACRE".

#
Note: The name matching is considered fuzzy, meaning it will not always provide the exact result that may be expected.
