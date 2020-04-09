#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Hides a given notification layer.
 *
 * Arguments:
 * 0: Notification layer <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_sys_list_hintLayer_0"] call acre_sys_list_fnc_hideHint
 *
 * Public: No
 */

params ["_layer"];

_layer cutFadeOut 1;
private _pointer = [_layer, 24, 25] call CBA_fnc_substring;
GVAR(hintBuffer) set [parseNumber _pointer, 0];
