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

private["_invalid"];
params["_var"];

_invalid = false;
if(!(_var isEqualType [])) exitWith { false };

_currentRadioList = [] call acre_api_fnc_getCurrentRadioList;
{
    if(!(_x isEqualType "")) exitWith {
        _invalid = true;
    };
    _isRadio = [_x] call acre_api_fnc_isRadio;
    if(!_isRadio) exitWith {
        _invalid = true;
    };
    if(!(_x in _currentRadioList)) exitWith {
        _invalid = false;
    };
} forEach ACRE_ASSIGNED_PTT_RADIOS;

if(_invalid) exitWith { false };

ACRE_ASSIGNED_PTT_RADIOS = _var;

true
