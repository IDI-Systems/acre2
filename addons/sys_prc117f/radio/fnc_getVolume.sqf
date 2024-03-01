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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_getVolume
 *
 * Public: No
 */

TRACE_1("",_this);

params ["", "", "", "_radioData"];

private _volume = HASH_GET(_radioData,"volume");
if (isNil "_volume") then {
    _volume = 1;
};
_volume^3;
