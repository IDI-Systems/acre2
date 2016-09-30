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

private _button = GET_STATE("pressedButton");
private _iconcontrol = 1000;
private _display = uiNamespace getVariable [QGVAR(currentDisplay), nil];
if(!isNil "_display") then {
    private _knobImageStr = QUOTE(PATHTOF(Data\Knobs\keypad\prc152c_ui_default.paa));
    (_display displayCtrl _iconcontrol) ctrlSetText _knobImageStr;
    SET_STATE("pressedButton",-1);
};
