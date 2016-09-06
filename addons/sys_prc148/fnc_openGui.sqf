/*
 * Author: AUTHOR
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





disableSerialization;
GVAR(currentRadioId) = _this select 0;
createDialog "PRC148_RadioDialog";
GVAR(PFHId) = ADDPFH(DFUNC(PFH), 0.33, []);
true
