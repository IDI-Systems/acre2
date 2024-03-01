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
 * [ARGUMENTS] call acre_sys_prc152_fnc_getOnOffState
 *
 * Public: No
 */

params ["_radioId", "_event", "_eventData", "_radioData"];

HASH_GET(_radioData,"radioOn");
