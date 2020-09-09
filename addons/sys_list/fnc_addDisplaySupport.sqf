#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds display ID to notification system.
 * Notifications are displayed on that display if it exists at the time of display.
 *
 * Arguments:
 * 0: Display ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [312] call acre_sys_list_fnc_addDisplaySupport
 *
 * Public: No
 */

params ["_displayId"];

GVAR(hintDisplays) pushBackUnique _displayId // return index
