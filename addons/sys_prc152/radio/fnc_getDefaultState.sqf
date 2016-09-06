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

private ["_value"];
params ["_id", "_default"];

_value = [GVAR(currentRadioId), "getState", _id] call EFUNC(sys_data,dataEvent);
if(isNil "_value") exitWith {
    _default;
};
_value;
