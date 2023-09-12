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
 * [ARGUMENTS] call acre_sys_prc117f_fnc_toggleButtonPressDown
 *
 * Public: No
 */

private _display = uiNamespace getVariable [QGVAR(currentDisplay), displayNull];
if (isNull _display) exitWith {};

private _button = toLower (_this select 0);
private _iconcontrol = 1000;
private _knobImageStr = QUOTE(\idi\acre\addons\sys_prc117f\Data\knobs\prc117f_ui_) + _button + QUOTE(.paa);
(_display displayCtrl _iconcontrol) ctrlSetText _knobImageStr;
SET_STATE("pressedButton",_button);

[GVAR(currentRadioId), FUNC(toggleButtonPressUp), 0.15] call FUNC(delayFunction)
