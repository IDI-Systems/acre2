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
 * [ARGUMENTS] call acre_sys_prc77_fnc_getOnOffState;
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_event", "_eventData", "_radioData"];

HASH_GET(_radioData, "radioOn");
