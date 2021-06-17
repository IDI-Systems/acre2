#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the current channel of the active radio.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 * 1: Event: "getCurrentChannel" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH>
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Current channel id <NUMBER>
 *
 * Example:
 * ["ACRE_BF888S_ID_1", "getCurrentChannel", [], _radioData, false] call acre_sys_bf888s_fnc_getCurrentChannel
 *
 * Public: No
 */

params ["", "", "", "_radioData", ""];

private _currentChannelId = HASH_GET(_radioData,"currentChannel");
if (isNil "_currentChannelId") then {
    _currentChannelId = 0;
};

_currentChannelId
