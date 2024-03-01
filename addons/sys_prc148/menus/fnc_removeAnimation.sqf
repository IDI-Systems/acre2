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
 * [ARGUMENTS] call acre_sys_prc148_fnc_removeAnimation
 *
 * Public: No
 */

params ["_id"];

private _animations = SCRATCH_GET_DEF(GVAR(currentRadioId),"animations",[]);
_animations set [_id, []];
