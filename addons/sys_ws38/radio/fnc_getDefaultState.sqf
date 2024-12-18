#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_ws38_fnc_getDefaultState
 *
 * Public: No
 */

params ["_id", "_default"];

private _value = [GVAR(currentRadioId), "getState", _id] call EFUNC(sys_data,dataEvent);
if (isNil "_value") exitWith {
    _default;
};
_value;
