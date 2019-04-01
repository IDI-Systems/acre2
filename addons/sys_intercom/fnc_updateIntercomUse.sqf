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

private _intercomNames = _vehicle getVariable [QGVAR(intercomNames), []];

{
    private _name = (_intercomNames select _forEachIndex) select 0;
    private _inUse = (_x findIf {_x in EGVAR(sys_core,speakers)}) != -1;
    GVAR(intercomUse) set [_forEachIndex, [_name, _inUse]];
} forEach _intercoms;
