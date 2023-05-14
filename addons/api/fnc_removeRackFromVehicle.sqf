#include "script_component.hpp"
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

params [
    ["_vehicle", objNull, [objNull]],
    ["_rackId", "", [""]]
];

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    false
};

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to remove a rack from an undefined vehicle %1",_vehicle);
    false
};

if (_rackId isEqualTo "") exitWith {
    WARNING_1("Empty rack name for vehicle %1",_vehicle);
    false
};

if (!([_vehicle] call FUNC(areVehicleRacksInitialized))) exitWith {
    WARNING_1("Vehicle %1 is not initialised. Rack is not being removed.",_vehicle);
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

[QEGVAR(sys_rack,removeVehicleRacks), [_vehicle, _rackId], _player] call CBA_fnc_targetEvent;

true

