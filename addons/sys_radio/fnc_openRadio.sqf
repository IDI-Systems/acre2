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

params ["_radioName"];

if (_radioName != "" && {GVAR(currentRadioDialog) == ""} && {[_radioName] call FUNC(canOpenRadio)}) then {
    private _openGui = [_radioName, "openGui"] call EFUNC(sys_data,interactEvent);
    //if (!_openGui) then {systemChat format ["cannot open GUI"]; closeDialog 0;};
} else {
    closeDialog 0;
};

true
