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
 * [ARGUMENTS] call acre_sys_prc152_fnc_render
 *
 * Public: No
 */

private ["_display"];
if (_this isNotEqualTo []) then {
    _display = _this select 0;
    uiNamespace setVariable [QGVAR(currentDisplay), _display];
} else {
    _display = uiNamespace getVariable [QGVAR(currentDisplay), displayNull];
};

private _knobPosition = GET_STATE_DEF("knobPosition",1);
private _knobImageStr = [_knobPosition, 1, 0] call CBA_fnc_formatNumber;
_knobImageStr = format ["\idi\acre\addons\sys_prc152\Data\knobs\channelknob\prc152c_ui_knob_%1.paa", _knobImageStr];
TRACE_1("Setting knob image",_knobImageStr);

(_display displayCtrl ICON_KNOB) ctrlSetText _knobImageStr;
(_display displayCtrl ICON_KNOB) ctrlCommit 0;

true
