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

params ["_radioId", "", "", "", ""];

[_radioId, false] call EFUNC(sys_radio,setRadioOpenState);

[GVAR(PFHId)] call CBA_fnc_removePerFrameHandler;
GVAR(currentRadioId) = nil;
true
