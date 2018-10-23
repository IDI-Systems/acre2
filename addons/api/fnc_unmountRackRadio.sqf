#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Removes a mounted radio. Must be executed on the server.
 *
 * Arguments:
 * 0: Rack ID <STRING> (default: "")
 * 1: Radio to unmount <STRING> (default: "")
 *
 * Return Value:
 * Setup successful <BOOL>
 *
 * Example:
 * ["ACRE_VRC103_ID_1", "ACRE_PRC117F_ID_1"] call acre_api_fnc_unmountRackRadio
 *
 * Public: Yes
 */

params [
    ["_rackId", "", [""]],
    ["_radioId", "", [""]]
];

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    false
};

// A player must do the action of unmounting a rack
private _player = objNull;

if (isDedicated) then {
    // Pick the first player
    _player = (allPlayers - entities "HeadlessClient_F") select 0;
} else {
    _player = acre_player;
};

[QEGVAR(sys_rack,unmountRackRadio), [_rackId, _radioId], _player] call CBA_fnc_targetEvent;

true
