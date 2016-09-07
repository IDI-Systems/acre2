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
 * Public: Yes
 */
#include "script_component.hpp"

params ["_radioType",["_array",[]]];

private _array = [];
private _ret = nil;

if (_array isEqualType objNull) then {
    _array = [_array] call EFUNC(lib,getGear);
} else {
    _array = [] call FUNC(getCurrentRadioList);
};

{
    private _radioId = _x;
    if( ([_radioId, _radioType] call FUNC(isKindOf) ) ) exitWith {
        _ret = _radioId;
    };
} forEach _array;

if(isNil "_ret") exitWith { nil };
_ret
