/*
 * Author: ACRE2Team
 * Disables all intercoms in the vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Setup succesful <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_api_fnc_disableIntercomsInVehicle
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull]];

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to disable intercoms in an undefined vehicle %1",format ["%1", _vehicle]);
    false
};

[_vehicle] call EFUNC(sys_intercom,disableIntercoms);

true
