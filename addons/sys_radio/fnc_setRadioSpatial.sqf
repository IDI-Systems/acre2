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
params["_radio","_side"];

if((isNil "_radio") || (isNil "_side")) exitWith {
    false
};

private _spatial = 0;
switch(_side) do {
    case "LEFT": {
        _spatial = -1;
    };
    case "RIGHT": {
        _spatial = 1;
    };
    case "CENTER": {
        _spatial = 0;
    };
    default {
        _spatial = 0;
    };
};

[_radio, "setSpatial", _spatial] call EFUNC(sys_data,dataEvent);

true
