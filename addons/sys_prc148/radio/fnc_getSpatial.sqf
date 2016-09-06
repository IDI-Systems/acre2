/*
 * Author: ACRE2Team
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

private["_spatial"];
params["_radioId"];

_spatial = [_radioId, "getState", "ACRE_INTERNAL_RADIOSPATIALIZATION"] call EFUNC(sys_data,dataEvent);

if(!isNil "_spatial") exitWith { _spatial };
0
