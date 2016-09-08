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

private _button = toLower (_this select 0);
private _iconcontrol = 99901;
private _display = uiNamespace getVariable [QUOTE(GVAR(currentDisplay)), nil];
if(!isNil "_display") then {
    //if (GET_STATE("pressedButton") < 0) Then {
        private _knobImageStr = QUOTE(\idi\acre\addons\sys_prc148\data\Knobs\keypad\prc148_ui_keys_) + _button + QUOTE(.paa);
        (_display displayCtrl _iconcontrol) ctrlSetText _knobImageStr;
        SET_STATE(pressedButton,_button);
        private _ret = [GVAR(currentRadioId), FUNC(toggleButtonPressUp), 0.15] call FUNC(delayFunction);
    //};
};
