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
 * [ARGUMENTS] call acre_sys_prc148_fnc_setState
 *
 * Public: No
 */

params ["_radioId", "", "_eventData", "_radioData"];

HASH_SET(_radioData, _eventData select 0, _eventData select 1);
if (_radioId == EGVAR(sys_radio,currentRadioDialog)) then {
    private _display = uiNamespace getVariable QGVAR(currentDisplay);
    [_display] call FUNC(render);
};
