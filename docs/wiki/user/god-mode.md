---
title: God Mode
---

{% include important.html content="Dev-build only" %}

ACRE2 offers the possibility of sending voice and text messages to groups of players without attenuation effects. This functionality is known as God Mode and consists of:

- Integration with Arma 3 Chat Channel: when pressing the corresponding Push-To-Talk (PTT), a voice message is going to be sent to those players matching the criteria of the current chat channel.
- Group presets: up to three configurable group presets that can be acessed throuhg a PTT. When pressing it, a voice message without attenuation is going to be sent to those players, including those that are not alive but in spectator mode. The group presets can be modified through the API function `acre_api_fnc_godModeModifyGroup`.
- Sending a text message to group presets by using `acre_api_fnc_godModeSendText` API function.

By default, Administrators and players in Zeus can access God Mode functionality. Its access can be further customized through the API function `acre_api_fnc_godModeConfigureAccess`.

## Example

{% raw %}
```cpp
// Allow access to Chat Channel and Group presets
[true, true] call acre_api_fnc_godModeConfigureAccess;

// Configure the groups
[[unit1, unit2], 0] call acre_api_fnc_godModeModifyGroup; // Group 1 
[[unit3, unit4], 1] call acre_api_fnc_godModeModifyGroup; // Group 2
[allPlayers, 2] call acre_api_fnc_godModeModifyGroup;     // Group 3

// Send a message to group 3 (0-based index)
["Server will restart...", 1] call acre_api_fnc_godModeSendText
```
{% endraw %}
