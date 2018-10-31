#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the given radio as mounted. Must be executed on the server.
 *
 * Arguments:
 * 0: Rack ID <STRING> (default: "")
 * 1: Base radio to mount <STRING> (default: "")
 *
 * Return Value:
 * Setup successful <BOOL>
 *
 * Example:
 * ["ACRE_VRC103_ID_1", "ACRE_PRC117F"] call acre_api_fnc_mountRackRadio
 *
 * Public: Yes
 */

params [
    ["_rackId", "", [""]],
    ["_baseRadio", "", [""]]
];

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    false
};

// A player must do the action of mounting a rack
private _player = objNull;

if (isDedicated) then {
    // Pick the first player
    _player = (allPlayers - entities "HeadlessClient_F") select 0;
} else {
    _player = acre_player;
};

[QEGVAR(sys_rack,mountRackRadio), [_rackId, _baseRadio], _player] call CBA_fnc_targetEvent;

true
