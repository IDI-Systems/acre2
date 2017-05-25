/*
 * Author: ACRE2Team
 * Initialises all racks in the vehicle. Must be executed in the server.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
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

params [["_vehicle", objNull]];

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

if (isDedicated) then {
    // Pick the first player
    _player = (allPlayers - entities "HeadlessClient_F") select 0;
} else {
    _player = acre_player;
};

[QGVAR(initVehicleRacks), [_vehicle], _player] call CBA_fnc_targetEvent;


true
