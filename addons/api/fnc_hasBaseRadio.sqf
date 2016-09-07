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

private["_type", "_ret", "_weapon"];
params["_unit"];

_ret = false;

{
    _weapon = _x;
    _ret = [_weapon] call FUNC(isBaseRadio);
    if(_ret) exitWith { _ret };
} foreach ([_unit] call EFUNC(lib,getGear));

_ret
