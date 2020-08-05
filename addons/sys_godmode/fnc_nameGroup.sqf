#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Set a visible name in the notification for the given group.
 *
 * Arguments:
 * 0: Name <STRING>
 * 1: Group to effect (0-based index) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["Admin", 0] call acre_sys_godmode_fnc_nameGroup
 *
 * Public: No
 */

params ["_name", "_group"];

GVAR(groupNames) set [_group, _name];
