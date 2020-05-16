#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Updates the ACRE_SPECTATORS_LIST global variable.
 *
 * Arguments:
 * 0: Mumble/TeamSpeak ID <NUMBER>
 * 1: Specatator status (1 = on, 0 = off) <NUMBER>
 * 2: Arma 3 Client ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [23,1] call acre_sys_server_fnc_setSpectator
 *
 * Public: No
 */

if (isServer) then {
    params ["_voipId", "_voipStatus", "_clientOwner"];
    private _preCount = count ACRE_SPECTATORS_LIST;
    if (_voipStatus == 1) then {
        if ((ACRE_SPECTATORS_LIST pushBackUnique _voipId) != -1) then {
            ACRE_SPECTATORS_A3_CLIENT_ID_LIST pushBack _clientOwner;
        };
    } else {
        private _idx = ACRE_SPECTATORS_LIST find _voipId;
        while {_idx != -1} do {
            ACRE_SPECTATORS_LIST deleteAt _idx;
            ACRE_SPECTATORS_A3_CLIENT_ID_LIST deleteAt _idx;
            _idx = ACRE_SPECTATORS_LIST find _voipId;
        };
    };
    // Only call publicVariable if array changes.
    if ((count ACRE_SPECTATORS_LIST) != _preCount) then {
        publicVariable "ACRE_SPECTATORS_LIST";
    };
};
