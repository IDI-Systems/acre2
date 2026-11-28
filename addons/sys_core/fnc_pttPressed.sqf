#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Notes a push-to-talk press, cancelling a release still waiting in acre_sys_core_fnc_pttReleased.
 *
 * Arguments:
 * 0: PTT name <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["intercom"] call acre_sys_core_fnc_pttPressed
 *
 * Public: No
 */

params ["_name"];

GVAR(pttPresses) set [_name, (GVAR(pttPresses) getOrDefault [_name, 0]) + 1];
