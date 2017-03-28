/*
 * Author: ACRE2Team
 * Updates the ACRE_SPECTATORS_LIST global variable.
 *
 * Arguments:
 * 0: TeamSpeak ID <NUMBER>
 * 1: Specatator status (1 = on, 0 = off) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [23,1] call acre_sys_server_fnc_setSpectator
 *
 * Public: No
 */
#include "script_component.hpp"

if (isServer) then {
    params ["_ts3Id","_tsStatus"];
    private _preCount = count ACRE_SPECTATORS_LIST;
    if (_tsStatus == 1) then {
        ACRE_SPECTATORS_LIST pushBackUnique _ts3Id;
    } else {
        ACRE_SPECTATORS_LIST = ACRE_SPECTATORS_LIST - [_ts3Id];
    };
    // Only call publicVariable if array changes.
    if ((count ACRE_SPECTATORS_LIST) != _preCount) then {
        publicVariable "ACRE_SPECTATORS_LIST";
    };
};
