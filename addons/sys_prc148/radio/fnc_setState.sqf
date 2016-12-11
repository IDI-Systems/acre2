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

params ["_radioId", "_event", "_eventData", "_radioData"];

HASH_SET(_radioData, _eventData select 0, _eventData select 1);
if (_radioId == acre_sys_radio_currentRadioDialog) then {
    _display = uiNamespace getVariable QGVAR(currentDisplay);
    [_display] call FUNC(render);
};
