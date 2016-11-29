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
 * [ARGUMENTS] call acre_sys_prc77_fnc_getCurrentChannel
 *
 * Public: No
 */
#include "script_component.hpp"

TRACE_1("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!GET CURRENT CHANNEL", _this);

params ["_radioId", "_event", "_eventData", "_radioData"];

private _return = 0;

_return
