/*
 * Author: ACRE2Team
 * Initialises all racks in the vehicle. Must be executed in the server. If no side is specified,
 * the radio will be configured to match the side of the first player.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Side <STRING> (default: "")
 *
 * Return Value:
 * Setup successful <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_api_fnc_initVehicleRacks
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull], ["_side", ""]];

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    false
};

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to initialize undefined vehicle %1",format ["%1", _vehicle]);
    false
};

if ([_vehicle] call FUNC(areVehicleRacksInitialized)) exitWith {
    WARNING_1("Vehicle %1 is already initialised",format ["%1", _vehicle]);
    false
};

// A player must do the action of initialising a rack
private _player = objNull;

if (_side isEqualTo "") then {
    _player = (allPlayers - entities "HeadlessClient_F") select 0;
} else {
    // Pick the first player that matches side criteria
    {
        if (side _x isEqualTo _side) then {
            _player = _x;
        };
    } forEach (allPlayers - entities "HeadlessClient_F");

    if (isNull _player) then {
        WARNING_1("No unit found for side %1, defaulting to first player",_side);
        _player = (allPlayers - entities "HeadlessClient_F") select 0;
    };
};

[QEGVAR(sys_rack,initVehicleRacks), [_vehicle], _player] call CBA_fnc_targetEvent;


true
