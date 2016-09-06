/*
 * Author: AUTHOR
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

private ["_mag", "_elev", "_dir"];



_mag = vectorMagnitude _this;
_elev = asin ((_this select 2) / _mag);
_dir = (360 + ((_this select 0) atan2 (_this select 1))) mod 360;

[_mag, _dir, _elev]
