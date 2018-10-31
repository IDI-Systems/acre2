#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initialises all racks in the vehicle. Must be executed in the server. If no condition is specified,
 * the radio will be configured to match the vehicle preset defined using acre_api_fnc_setVehicleRacksPreset
 * or the preset of the first player that matches the given condition if the vehicle preset is not defined.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Condition called with argument "_unit". If a longer function is given, it should be precompiled. <CODE> (default: {})
 *
 * Return Value:
 * Setup successful <BOOL>
 *
 * Example:
 * [cursorTarget, {}] call acre_api_fnc_initVehicleRacks
 *
 * Public: Yes
 */

params [
    ["_vehicle", objNull, [objNull]],
    ["_condition", {}, [{}]]
];

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

private _vehiclePresetName = [_vehicle] call FUNC(getVehicleRacksPreset);
if (_condition isEqualTo {} && {!(_vehiclePresetName isEqualTo "")}) then {
    _player = ([] call CBA_fnc_players) select 0;
} else {
    // Pick the first player that matches side criteria
    {
        if ([_x] call _condition) exitWith {
            _player = _x;
        };
    } forEach ([] call CBA_fnc_players);

    if (isNull _player) then {
        WARNING_1("No unit found for condition %1, defaulting to first player",_condition);
        _player = ([] call CBA_fnc_players) select 0;
    };
};

_vehicle setVariable [QEGVAR(sys_rack,initPlayer), _player, true];

[QEGVAR(sys_rack,initVehicleRacks), [_vehicle], _player] call CBA_fnc_targetEvent;

true
