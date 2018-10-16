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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

TRACE_1("", _this);

params ["_radioId", "_event", "_eventData", "_radioData"];

private _volume = HASH_GET(_radioData,"volume");
if (isNil "_volume") then {
    _volume = 1;
};
_volume^3;
