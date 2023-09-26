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
 * [ARGUMENTS] call acre_sys_prc148_fnc_changeState
 *
 * Public: No
 */

params ["_radioId", "_state", ["_menuPage", 0], ["_menuIndex", 0], ["_entryCursor", 0], ["_selectedEntry", -1]];

private _editEntry = false;

if ((count _this) > 4) then {
    _editEntry = true;
};

private _currentState = ["getState", "currentState"] call GUI_DATA_EVENT;
//diag_log text format["setting last state: %1", [_currentState, PAGE_INDEX, MENU_INDEX, ENTRY_INDEX, SELECTED_ENTRY]];
[_radioId, "setState", ["lastState", [_currentState, PAGE_INDEX, MENU_INDEX, ENTRY_INDEX, SELECTED_ENTRY]]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["editEntry", _editEntry]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["currentState", _state]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["menuPage", _menuPage]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["menuIndex", _menuIndex]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["entryCursor", _entryCursor]] call EFUNC(sys_data,dataEvent);
[_radioId, "setState", ["selectedEntry", _selectedEntry]] call EFUNC(sys_data,dataEvent);


if (_radioId == EGVAR(sys_radio,currentRadioDialog)) then {
    private _display = uiNamespace getVariable QGVAR(currentDisplay);
    [_display] call FUNC(render);
};
