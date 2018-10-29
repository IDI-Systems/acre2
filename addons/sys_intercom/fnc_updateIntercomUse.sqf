#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if intercoms are in use. Used by intercom accent.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Units connected to intercom <ARRAY>
 * 2: Intercom identifiers <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_updateIntercomUse
 *
 * Public: No
 */

params ["_vehicle", "_intercoms", "_intercomNames"];

private _intercomNanes = _vehicle getVariable [QGVAR(intercomNames), []];
{
    GVAR(intercomUse) set [_forEachIndex, [(_intercomNames select _forEachIndex) select 0, (_x findIf {_x in EGVAR(sys_core,speakers)}) != -1]];
} forEach _intercoms;
