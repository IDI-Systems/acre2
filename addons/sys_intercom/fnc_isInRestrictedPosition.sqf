/*
 * Author: ACRE2Team
 * Checks if a unit is in a restricted intercom position.
 *
 * Arguments:
 * 0: Vehicle with intercom action <OBJECT>
 * 1: Unit to be checked <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * Unit is in a restricted intercom position
 *
 * Example:
 * [cursorTarget, acre_player, 0] call acre_sys_intercom_fnc_isInRestrictedPositions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_intercomNetwork"];

_unit in ((_vehicle getVariable [QGVAR(unitsRestrictedPositions), []]) select _intercomNetwork);
