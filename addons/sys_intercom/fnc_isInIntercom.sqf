/*
 * Author: ACRE2Team
 * Checks if a unit is in the given intercom network of a vehicle.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * Unit is in the given intercom network <BOOL>
 *
 * Example:
 * [cursorTarget, acre_player, 0] call acre_sys_intercom_fnc_isInIntercom
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_intercomNetwork"];

_unit in ((_vehicle getVariable [QGVAR(unitsIntercom), []]) param [_intercomNetwork,[]])
