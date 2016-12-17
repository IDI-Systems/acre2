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

private _iconcontrol = 1000;
private _display = uiNamespace getVariable [QGVAR(currentDisplay), nil];
if (!isNil "_display") then {
    private _knobImageStr = QUOTE(PATHTOF(Data\knobs\prc117f_ui_keys_default.paa));
    (_display displayCtrl _iconcontrol) ctrlSetText _knobImageStr;
    SET_STATE("pressedButton",-1);
};
