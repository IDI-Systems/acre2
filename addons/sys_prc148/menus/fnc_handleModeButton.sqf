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

private ["_alt"];
_alt = _this select 7;
if(_alt) then {
    [GVAR(currentRadioId), "ProgrammingDisplay"] call FUNC(changeState);
} else {
    [GVAR(currentRadioId), "ModeDisplay"] call FUNC(changeState);
};
