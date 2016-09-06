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

params["_radioName"];

if(_radioName != "" && GVAR(currentRadioDialog) == "") then {
    [_radioName, "openGui"] call EFUNC(sys_data,interactEvent);
} else {
    closeDialog 0;
};

true
