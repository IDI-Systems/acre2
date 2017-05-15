/*
 * Author: ACRE2Team
 * Check if racks are disabled for a particular vehicle
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Are racks disabled? <BOOL>
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_fnc_areRacksDisabled
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

_vehicle getVariable [QGVAR(disabledRacks), false]
