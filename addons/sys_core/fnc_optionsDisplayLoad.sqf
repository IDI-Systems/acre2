#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Adds an "ACRE Microphone Test" button to the Options menu, below its column of buttons.
 *
 * Arguments:
 * 0: Options display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call acre_sys_core_fnc_optionsDisplayLoad
 *
 * Public: No
 */

#define CT_SHORTCUTBUTTON 16

params ["_display"];

if (!hasInterface) exitWith {};

// The menu's buttons: find the column most of them share, and its lowest button.
private _buttons = (allControls _display) select {ctrlType _x == CT_SHORTCUTBUTTON && {ctrlShown _x}};
if (_buttons isEqualTo []) exitWith {};
private _columns = createHashMap;
{
    private _x0 = (ctrlPosition _x select 0) toFixed 3;
    _columns set [_x0, (_columns getOrDefault [_x0, []]) + [_x]];
} forEach _buttons;
private _column = [];
{
    if (count _y > count _column) then { _column = _y; };
} forEach _columns;

// Sort by y (top to bottom).
private _positions = _column apply {[ctrlPosition _x select 1, ctrlPosition _x]};
_positions sort true;
((_positions select (count _positions - 1)) select 1) params ["_buttonX", "_buttonY", "_buttonW", "_buttonH"];
private _step = _buttonH * 1.1;
if (count _positions > 1) then {
    _step = _buttonY - ((_positions select (count _positions - 2)) select 0);
};

private _button = _display ctrlCreate ["RscButtonMenu", -1];
_button ctrlSetPosition [_buttonX, _buttonY + _step, _buttonW, _buttonH];
_button ctrlSetText localize LSTRING(micTest_title);
_button ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    [ctrlParent _control] call FUNC(micTestOpen);
}];
_button ctrlCommit 0;
