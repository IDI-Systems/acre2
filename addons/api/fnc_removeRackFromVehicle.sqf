/*
 * Author: ACRE2Team
 * Initialises all racks in the vehicle. Must be executed in the server.
 *
 * Arguments:
 * 0: Vehicle <OBJECT> (default: objNull)
 * 1: Unique rack ID <STRING>
 *
 * Return Value:
 * Rack removed successfully <BOOL>
 *
 * Example:
 * [cursorTarget, "ACRE_VRC103_ID_1"] call acre_api_fnc_removeRackFromVehicle
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull], "_rackId"];

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    false
};

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to remove a rack from an undefined vehicle %1",format ["%1", _vehicle]);
    false
};

if (!([_vehicle] call FUNC(areVehicleRacksInitialized))) exitWith {
    WARNING_1("Vehicle %1 is not initialised. Rack is not being removed.",format ["%1", _vehicle]);
    false
};

// A player must do the action of removing a rack
private _player = objNull;

if (isDedicated) then {
    // Pick the first player
    _player = (allPlayers - entities "HeadlessClient_F") select 0;
} else {
    _player = acre_player;
};

[QGVAR(removeVehicleRacks), [_vehicle, _rackId], _vehicle] call CBA_fnc_targetEvent;

{
    private _type = typeOf _x;

    if (_type == (toLower _rackId)) exitWith {
        deleteVehicle _x;
    };
} forEach (nearestObjects [[-1000,-1000], ["ACRE_baseRack"], 1, true]);

true

