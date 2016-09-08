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

params ["_hintIDD"];

(_hintIDD displayCtrl 19100) ctrlSetText GVAR(hintTitle);
(_hintIDD displayCtrl 19101) ctrlSetText GVAR(hintLine1);
(_hintIDD displayCtrl 19102) ctrlSetText GVAR(hintLine2);
