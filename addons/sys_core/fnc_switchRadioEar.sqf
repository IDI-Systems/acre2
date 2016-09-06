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

params["_ear"];

private _radioId = ACRE_ACTIVE_RADIO;

switch _ear do {
    case -1: {
        hintSilent "LEFT EAR";
    };
    case 0: {
        hintSilent "CENTER EAR";
    };
    case 1: {
        hintSilent "RIGHT EAR";
    };
};
//[_radioId, "setState", ["ACRE_INTERNAL_RADIOSPATIALIZATION", _ear]] call EFUNC(sys_data,dataEvent);
[_radioId, "setSpatial", _ear] call EFUNC(sys_data,dataEvent);

true
