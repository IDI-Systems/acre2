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

params ["_params"];
_params params ["_function", "_parameters", "_frameNo"];

if(_frameNo != diag_frameNo) then {
    _parameters call _function;
    [(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
};
