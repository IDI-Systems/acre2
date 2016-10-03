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

private["_display"];
if((count _this) > 0) then {
    _display = _this select 0;
    uiNamespace setVariable [QUOTE(GVAR(currentDisplay)), _display];
} else {
    _display = uiNamespace getVariable [QUOTE(GVAR(currentDisplay)), nil];
};

_knobPosition = GET_STATE_DEF("knobPosition", 1);
_knobImageStr = [_knobPosition, 2, 0] call CBA_fnc_formatNumber;
_knobImageStr = format["\idi\acre\addons\sys_prc117f\Data\knobs\switch\prc117f_ui_swtch1_%1.paa", _knobImageStr];
TRACE_1("Setting knob image", _knobImageStr);

(_display displayCtrl ICON_KNOB) ctrlSetText _knobImageStr;
(_display displayCtrl ICON_KNOB) ctrlCommit 0;

true
