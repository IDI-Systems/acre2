#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_data_fnc_getRadioPresetName
 *
 * Public: No
 */

params ["_class"];

private _return = HASH_GET(GVAR(assignedRadioPresets),_class);

if (isNil "_return") then {
    _return = "default";
};

_return
