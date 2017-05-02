/*
 * Author: ACRE2Team
 * Checks if a unit is in the crew intercom of a vehicle.
 *
 * Arguments:
 * 0: Vehicle with a crew intercom action <OBJECT>
 * 1: Unit to be checked <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, acre_player] call acre_sys_intercom_isInCrewIntercom
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit"];

_unit in (_vehicle getVariable [QGVAR(unitsCrewIntercom), []])
