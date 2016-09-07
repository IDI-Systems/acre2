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

private _number = _this;
private _tempStr = "";

while { _number >= 1 } do {
    private _digit = (floor _number) % 10;
    _tempStr = _tempStr + toString [(_digit+48)];
    _number = floor (_number / 10);
};

private _tempArray = toArray _tempStr;
private _count = (count _tempArray) - 1;
private _str = "";
while { _count >= 0 } do {
    _str = _str + toString[(_tempArray select _count)];
    _count = _count - 1;
};
//TRACE_2("converted",_number, _str);
_str
