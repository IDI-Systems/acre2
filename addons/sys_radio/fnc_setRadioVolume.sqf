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

params["_radio", "_volume"];

if(isNil "_radio") exitWith {};
if(isNil "_volume") exitWith {};

_volume = ((_volume min 1) max 0);

[_radio, "setVolume", _volume] call EFUNC(sys_data,dataEvent);
