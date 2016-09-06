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

private["_unit", "_ret", "_weapon"];
params["_weaponArray", "_type"];

if(IS_OBJECT(_weaponArray)) then {
    _weaponArray = [_weaponArray] call EFUNC(lib,getGear);
};

_ret = false;
if(_type in _weaponArray) then {
    _ret = true;
} else {
    {
        _weapon = _x;
        _ret = [_weapon, _type] call FUNC(isKindOf);
        if(_ret) exitWith { };
    } foreach _weaponArray;
};

_ret
