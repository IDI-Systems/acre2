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

private ["_spatial"];
params["_radioId", "_event", "_eventData", "_radioData"];

_spatial = _eventData;

[_radioId, "setState", ["ACRE_INTERNAL_RADIOSPATIALIZATION", _spatial]] call EFUNC(sys_data,dataEvent);
