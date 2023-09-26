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
 * [ARGUMENTS] call acre_sys_prc148_fnc_toggleButtonPressUp
 *
 * Public: No
 */

private _button = GET_STATE("pressedButton");
private _iconcontrol = 99901;
private _display = uiNamespace getVariable [QGVAR(currentDisplay), displayNull];
if (!isNull _display) then {
    private _knobImageStr = QPATHTOF(Data\knobs\keypad\prc148_ui_keys_default.paa);
    (_display displayCtrl _iconcontrol) ctrlSetText _knobImageStr;
    SET_STATE("pressedButton",-1);
};
