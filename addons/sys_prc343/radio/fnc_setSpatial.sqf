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
 * [ARGUMENTS] call acre_sys_prc343_fnc_setSpatial;
 *
 * Public: No
 */
#include "script_component.hpp"

params["_radioId",  "_event", "_eventData", "_radioData"];

private _spatial = _eventData;

[_radioId, "setState", ["ACRE_INTERNAL_RADIOSPATIALIZATION", _spatial]] call EFUNC(sys_data,dataEvent);
