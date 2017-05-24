/*
 * Author: ACRE2Team
 * Initialises all racks in the vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Rack configuration <ARRAY>
 *   0: Display name <STRING>
 *   1: Rack base type <STRING>
 *   2: Allowed positions <ARRAY>
 *   3: Disabled positions <ARRAY>
 *   4: Components <ARRAY>
 *   5: Mounted radio base type <STRING>
 *   6: Can radio be removed <BOOL>
 *   7: Connected intercoms <ARRAY>
 * 2: Force initialisation <BOOL><OPTIONAL> (default: false)
 *
 * Return Value:
 * Rack added successfully <BOOL>
 *
 * Example:
 * [cursorTarget, ["Comm 1","ACRE_VRC103", ["external"], [], [], "ACRE_PRC117F", false, ["crew"]]] call acre_api_fnc_addRackToVehicle
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull], "_rackConfiguration", ["_forceInitialisation", false]];

if (!isServer) exitWith {
    WARNING("Function must be called on the server.");
    false
};

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to initialize undefined vehicle %1",format ["%1", _vehicle]);
    false
};

private _vehicleInitialized = [_vehicle] call FUNC(areVehicleRacksInitialized);
if (!_vehicleInitialized && !_forceInitialisation) exitWith {
    WARNING_1("Vehicle %1 is not initialised. Rack is not being added.",format ["%1", _vehicle]);
    false
};

private _success = true;

if (_forceInitialisation) then {
    if (_vehicleInitialized) then {
        WARNING_1("Vehicle %1 is already initialised but function forces it to initialise again",format ["%1", _vehicle]);
    } else {
        TRACE_1("Forcing initialisation of vehicle %1 in order to add a rack",format ["%1", _vehicle]);
        _success = [_vehicle] call FUNC(initVehicleRacks);
    };
};

if (!_success) exitWith {
    WARNING_1("Vehicle %1 failed to initialise",format ["%1", _vehicle]);
};

if (count _rackConfiguration != 8) exitWith {
    WARNING_1("Invalid number of entries in the rack configuration array for vehicle: %1",format ["%1", _vehicle]);
    false
};

_rackConfiguration params ["_displayName", "_componentName", "_allowedPos", "_disabledPos", "_components", "_mountedRadio", "_isRadioRemovable", "_intercoms"];

private _allowed = [_vehicle, _allowedPos] call EFUNC(sys_core,processConfigArray);
private _disabled = [_vehicle, _disabledPos] call EFUNC(sys_core,processConfigArray);
_intercoms = _intercoms apply {toLower _x};

if (isDedicated) then {
    // Pick the first player:
    private _player = (allPlayers - entities "HeadlessClient_F") select 0;
    [QGVAR(addVehicleRacks), [_vehicle, _componentName, _displayName, _isRadioRemovable, _allowed, _disabled, _mountedRadio, _components, _intercoms], _player] call CBA_fnc_targetEvent;
} else {
    [_vehicle, _componentName, _displayName, _isRadioRemovable, _allowed, _disabled, _mountedRadio, _components, _intercoms] call EFUNC(sys_rack,addRack);

    if (count _intercoms > 0) then {
        _vehicle setVariable [QEGVAR(sys_rack,rackIntercomInitialised), false, true];
    };
};

true
