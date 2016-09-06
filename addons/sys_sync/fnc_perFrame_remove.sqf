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

params["_handle"];
if (isNil "_handle") exitWith {}; // Nil handle, nil action
GVAR(perFrameHandlerArray) set [_handle, nil];
_newArray = [];
for "_i" from (count GVAR(perFrameHandlerArray))-1 to 0 step -1 do {
    _entry = GVAR(perFrameHandlerArray) select _i;
    if(isNil "_entry") then {
        GVAR(nextPFHid) = _i;
    } else {
        _newArray set[_i, _entry];
    };
};
GVAR(perFrameHandlerArray) = _newArray;

true;
