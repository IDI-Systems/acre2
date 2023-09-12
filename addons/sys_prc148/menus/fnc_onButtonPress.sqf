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
 * [ARGUMENTS] call acre_sys_prc148_fnc_onButtonPress
 *
 * Public: No
 */

params ["_button"];

[_button] call FUNC(toggleButtonPressDown);

private _currentState = ["getState", "currentState"] call GUI_DATA_EVENT;
private _buttonFunction = format ["%1_fnc_%2_%3", QUOTE(ADDON), _currentState, _button];
//acre_player sideChat format["BUTTON: %1", _buttonFunction];
//diag_log text format["EDIT: %1", GET_STATE("editEntry")];
if (!GET_STATE("editEntry")) then {
    //diag_log text format["trying: %1", _buttonFunction];
    _this call (missionNamespace getVariable [_buttonFunction, FUNC(defaultButtonHandler)]);
} else {
    //diag_log text format["doing: %1", _buttonFunction];
    _this call FUNC(defaultButtonHandler);
};
