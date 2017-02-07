/*
 * Author: ACRE2Team
 * Returns the current channel of the active radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event (Unused) <STRING>
 * 2: Event data (Unused) <NUMBER>
 * 3: Radio data <HASH>
 *
 * Return Value:
 * Current channel id <NUMBER>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_prc343_fnc_getCurrentChannel;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["", "", "", "_radioData"];

private _currentChannelId = HASH_GET(_radioData,"currentChannel");
if (isNil "_currentChannelId") then {
    _currentChannelId = 0;
};

_currentChannelId
