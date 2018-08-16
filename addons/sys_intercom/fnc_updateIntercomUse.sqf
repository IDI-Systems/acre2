/*
 * Author: ACRE2Team
 * Checks if intercoms are in use. Used by intercom accent.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Units connected to intercom <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_intercomsInUse
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_intercoms", "_intercomNames"];

_intercomN_vehicle getVariable [QGVAR(intercomNames), []];

{
    GVAR(intercomUse) set [_forEachIndex, [_intercomNames # _forEachIndex, _x findIf {_x in EGVAR(sys_core,speakers)} != -1]];
} forEach _intercoms;
