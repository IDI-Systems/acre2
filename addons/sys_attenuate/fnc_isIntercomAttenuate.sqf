/*
 * Author: ACRE2Team
 * Checks if the unit should be heard on vehicle intercom or not for the local player.
 *
 * Arguments:
 * 0: Unit to be evaluated <OBJECT>
 *
 * Return Value:
 * Is other unit speaking on intercom <Boolean>
 *
 * Example:
 * [unit] call acre_sys_attenuate_fnc_isIntercomAttenuate
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];

private _ret = false;

{
    if (_unit in _x) exitWith { _ret =  true };
} forEach ACRE_PLAYER_INTERCOM;

_ret
