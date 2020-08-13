---
title: God Mode
---

{% include important.html content="Dev-build only" %}

All [God Mode](/wiki/user/god-mode) configuration only applies to the local machine. This allows great flexibility in configuration and different group presets for each player.

## Access

Current Chat Channel and Groups have separate access rights.

```js
// Allow access to Chat Channel but not Group presets
[true, false] call acre_api_fnc_godModeConfigureAccess;
```


## Group Presets

Group presets can be handled in various ways, from direct units, player UIDs, to a more advanced dynamic target selection (provided by caller code).

Groups are handled on the basis of a unit. Because all configuration is local, it is important target units do not change their locality to reach the same physical machine.

### Direct

Most simple configuration, very useful for mid-sized missions. Simply put down the target units as wanted.

```js
[[unit1, unit2], 0] call acre_api_fnc_godModeModifyGroup; // Group 1
[[unit3, unit4], 1] call acre_api_fnc_godModeModifyGroup; // Group 2
[allPlayers, 2] call acre_api_fnc_godModeModifyGroup;     // Group 3
```

It is also possible to add or remove units dynamically. This can be used in a custom unit selection dialog for example.

```js
[[unit10, unit11], 0, 1] call acre_api_fnc_godModeModifyGroup; // Add units to Group 1
[[unit5, unit6], 0, 2] call acre_api_fnc_godModeModifyGroup; // Remove units from Group 1
```

### UID

When using systems that switch units or administrators are hard-coded, Steam UID of that player may be used.

```js
[["75692039601236937"], 0] call acre_api_fnc_godModeModifyGroup;
```

_Note: Using `getPlayerUID UNIT` will not work, as one player may load in before another does. Only editor-placed unit names are supported in this way._

### Dynamic

It is also possible to provide target units dynamically, when the player presses his PTT button. This is achieved by passing target parameter as code which returns a list of target units that should receive transmission on that group.

This is an advanced configuration, make sure code is fast, otherwise it can cause delays between pressing the PTT and the beginning of the transmission!

```js
// Transmit to all alive units only
[{
    allUnits select {alive _x}
}, 0] call acre_api_fnc_godModeModifyGroup;
```

_Note: Only 0 (set) operation is supported when providing targets dynamically._


### Group Names

Groups can be named to give them a different name in Transmit and Receive notifications. Group names are also local, but receiving players will see the group name of the transmitting player. This is because both players might not have the same group presets, but want to see who the message is aimed at.

```js
["Admins", 1] call acre_api_fnc_godModeNameGroup;
```


## Text Messages

```js
// Send a message to group 2 (0-based index)
["Server will restart...", 1] call acre_api_fnc_godModeSendText;
```
