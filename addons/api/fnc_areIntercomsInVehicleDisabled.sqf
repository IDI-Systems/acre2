/*
 * Author: ACRE2Team
 * Returns if intercoms in the vehicle are disabled.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Are racks disabled? <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_api_fnc_areIntercomsInVehicleDisabled
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull]];

if (isNull _vehicle) exitWith {
    WARNING_1("Trying to get intercom status in an undefined vehicle %1",format ["%1", _vehicle]);
};

[_vehicle] call EFUNC(sys_intercom,areIntercomsDisabled)
