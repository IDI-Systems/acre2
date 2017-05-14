/*
 * Author: ACRE2Team
 * Returns the unique identity of the current channel.
 *
 * Arguments:
 * 0: Radio ID <STRING> (Unused)
 *
 * Return Value:
 * Identity of the current channel <NUMBER>
 *
 * Example:
 * ["ACRE_PRC77_ID_1"] call acre_sys_prc77_fnc_getCurrentChannelInternal
 *
 * Public: No
 */
#include "script_component.hpp"

TRACE_1("GET CURRENT CHANNEL", _this);

params ["", "", "", "_radioData", ""];

private _currentChannelId = HASH_GET(_radioData,"currentChannel");
if (isNil "_currentChannelId") then {
    _currentChannelId = [0,0];
};

_currentChannelId
