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
private["_iconcontrol", "_display", "_button"];
_button = GET_STATE(pressedButton);
_iconcontrol = 99901;
_display = uiNamespace getVariable [QUOTE(GVAR(currentDisplay)), nil];
if(!isNil "_display") then {
    _knobImageStr = QUOTE(PATHTOF(Data\knobs\keypad\prc148_ui_keys_default.paa));
    (_display displayCtrl _iconcontrol) ctrlSetText _knobImageStr;
    SET_STATE(pressedButton,-1);
};
