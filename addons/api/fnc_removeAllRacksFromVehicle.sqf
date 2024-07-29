#include "script_component.hpp"
/*
 * Author: mrschick
 * Removes all Racks from a vehicle. Must be executed on the server.
 *
 * Arguments:
 * 0: Vehicle <OBJECT> (default: objNull)
 *
 * Return Value:
 * Racks removed successfully <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_api_fnc_removeAllRacksFromVehicle
 *
 * Public: Yes
 */

params [
    ["_vehicle", objNull, [objNull]]
];

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    false
};

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to remove a rack from an undefined vehicle %1",_vehicle);
    false
};

private _success = true;

if (!([_vehicle] call FUNC(areVehicleRacksInitialized))) then {
    WARNING_1("Forcing initialisation of vehicle %1 in order to remove all racks",_vehicle);
    _success = [_vehicle] call EFUNC(api,initVehicleRacks);
};

if (!_success) exitWith {
    WARNING_1("Vehicle %1 failed to initialise",_vehicle);
};

// A player must do the action of removing a rack
private _player = objNull;

if (isDedicated) then {
    // Pick the first player
    _player = (allPlayers - entities "HeadlessClient_F") select 0;
} else {
    _player = acre_player;
};

[{
    params ["_vehicle", "_player"];
    [_vehicle] call FUNC(areVehicleRacksInitialized)
}, {
    params ["_vehicle", "_player"];

    private _racks = [_vehicle] call FUNC(getVehicleRacks);
    for "_i" from (count _racks) - 1 to 0 step -1 do {
        [QEGVAR(sys_rack,removeVehicleRacks), [_vehicle, _racks select _i], _player] call CBA_fnc_targetEvent;
    };
}, [_vehicle, _player]] call CBA_fnc_waitUntilAndExecute;

true
