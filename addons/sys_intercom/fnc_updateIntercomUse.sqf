#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if intercoms are in use. Used by intercom accent.
 *
 * Arguments:
 * 0: Units connected to intercom <ARRAY>
 * 1: Intercom identifiers <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[johm, joe, toe], ["intercom_1"]] call acre_sys_intercom_fnc_updateIntercomUse
 *
 * Public: No
 */

params ["_intercoms", "_intercomNames"];

if (count _intercomNames != count _intercoms) exitWith {
    // This can happen when deleting the vehicle but when the PFH still runs. Intercom points to a persistent array
    // while intercomNames is a vehicle variable. This missmatch can happen when a vehicle is deleted or a player is
    // removed from a vehicle using Zeus while the vehicle is being deleted.
    GVAR(intercomUse) = [];
};

{
    private _name = (_intercomNames select _forEachIndex) select 0;
    private _inUse = (_x findIf {_x in EGVAR(sys_core,speakers)}) != -1;
    GVAR(intercomUse) set [_forEachIndex, [_name, _inUse]];
} forEach _intercoms;
