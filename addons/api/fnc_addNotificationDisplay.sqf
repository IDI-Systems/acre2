#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds notification system support to given display ID (IDD).
 *
 * Arguments:
 * 0: Display ID <NUMBER>
 *
 * Return Value:
 * Display priority index <NUMBER>
 *
 * Example:
 * [3333] call acre_api_fnc_addNotificationDisplay
 *
 * Public: Yes
 */

if (!hasInterface) exitWith {};

params [["_displayId", -1, [0]]];

_displayId call EFUNC(sys_list,addDisplaySupport)
