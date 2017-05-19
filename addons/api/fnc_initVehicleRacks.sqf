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

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to initialize undefined vehicle %1",format ["%1", _vehicle]);
    false
};

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
    [_vehicle] call EFUNC(sys_rack,initActionVehicle);
};

true
