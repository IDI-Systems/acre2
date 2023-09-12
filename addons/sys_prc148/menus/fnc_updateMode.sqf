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
 * [ARGUMENTS] call acre_sys_prc148_fnc_updateMode
 *
 * Public: No
 */

params ["_newVal", "_entry"];
_entry params ["_key", "_oldVal"];

[GVAR(currentRadioId), "setStateCritical", [_key, _newVal]] call EFUNC(sys_data,dataEvent);
