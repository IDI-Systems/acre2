#include "script_component.hpp"

private["_button", "_iconcontrol", "_display", "_knobImageStr"];

_button = toLower (_this select 0);
_iconcontrol = 99901;
_display = uiNamespace getVariable [QUOTE(GVAR(currentDisplay)), nil];
if(!isNil "_display") then {
    //if (GET_STATE("pressedButton") < 0) Then {
        _knobImageStr = QUOTE(\idi\clients\acre\addons\sys_prc148\data\Knobs\keypad\prc148_ui_keys_) + _button + QUOTE(.paa);
        (_display displayCtrl _iconcontrol) ctrlSetText _knobImageStr;
        SET_STATE(pressedButton,_button);
        _ret = [GVAR(currentRadioId), FUNC(toggleButtonPressUp), 0.15] call FUNC(delayFunction);
    //};
};
