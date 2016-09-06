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

params ["_func", "_delay", ["_params", []], ["_functionName", "Unknown Function"]];

private _handle = -1;
if(!isNil "_func") then {
    _handle = GVAR(nextPFHid);
    if(_handle == -1) then {
        _handle = (count GVAR(perFrameHandlerArray));
    } else {
        _test = GVAR(perFrameHandlerArray) select _handle;
        if(!(isNil "_test")) then {
            _handle = (count GVAR(perFrameHandlerArray));
        };
    };
    private _data = [_func, _delay, 0, diag_tickTime, _params, _handle, _functionName];
    GVAR(perFrameHandlerArray) set [_handle, _data];
};
_handle
