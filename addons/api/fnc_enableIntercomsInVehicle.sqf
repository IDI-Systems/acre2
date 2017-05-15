/*
 * Author: ACRE2Team
 * Enables all intercoms in the vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Setup succesful <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_api_fnc_enableIntercomsInVehicle
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull]];

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to enable intercoms in an undefined vehicle %1",format ["%1", _vehicle]);
    false
};

[_vehicle] call EFUNC(sys_intercom,enableIntercoms);

true
