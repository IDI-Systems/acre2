/*
 * Author: ACRE2Team
 * Check if intercoms are disabled for a particular vehicle
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Are intercoms disabled? <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_areIntercomssDisabled
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

_vehicle getVariable [QGVAR(disabledIntercoms), false]
