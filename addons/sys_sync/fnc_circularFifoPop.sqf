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

private["_deleteArray", "_newHandle", "_i"];
params["_handle"];

_handle params ["_value"];
_handle set[0, -999999];
_deleteArray = [-999999];
_newHandle = _handle - _deleteArray;
PUSH(_newHandle, _value);

_i = 0;
TRACE_1("", _newHandle);
while { _i < (count _newHandle) } do {
    _handle set[_i, (_newHandle select _i)];
    _i = _i + 1;
};
TRACE_2("", _value, _handle);


_value
