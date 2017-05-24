/*
 * Author: ACRE2Team
 * Initialises all racks in the vehicle.
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
if (isDedicated) then {
    // Pick the first player
    private _player = (allPlayers - entities "HeadlessClient_F") select 0;
    [QGVAR(initVehicleRacks), [_vehicle], _player] call CBA_fnc_targetEvent;
} else {
    [_vehicle] call EFUNC(sys_rack,initVehicle);

    // Some classes are initialised automatically. Only initialise ACE interaction if the vehicle does not belong to
    // any of these classes
    private _found = false;
    private _automaticInitClasses = ["LandVehicle", "Air", "Ship_F"];
    {
        if (_vehicle isKindOf _x) exitWith {
            _found = true;
        };
    } forEach _automaticInitClasses;

    if (!_found) then {
        [QGVAR(initVehicleRacksActions), [_vehicle]] call CBA_fnc_globalEventJIP;
    };
};

true
