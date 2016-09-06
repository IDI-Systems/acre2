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
private ["_array", "_radioId", "_ret"];
params ["_radioType"];

_ret = nil;

if((count _this) > 1) then {
    _array = _this select 1;
    if(IS_OBJECT(_array)) then {
        _array = [_array] call EFUNC(lib,getGear);
    };
} else {
    _array = [] call FUNC(getCurrentRadioList);
};


{
    _radioId = _x;
    if( ([_radioId, _radioType] call FUNC(isKindOf) ) ) exitWith {
        _ret = _radioId;
    };
} forEach _array;

if(isNil "_ret") exitWith { nil };
_ret
