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
 * [ARGUMENTS] call acre_sys_prc148_fnc_handleModeButton
 *
 * Public: No
 */

private _alt = _this select 7;
if (_alt) then {
    [GVAR(currentRadioId), "ProgrammingDisplay"] call FUNC(changeState);
} else {
    [GVAR(currentRadioId), "ModeDisplay"] call FUNC(changeState);
};
