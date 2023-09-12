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
 * [ARGUMENTS] call acre_sys_sem70_fnc_onDisplayButtonPress
 *
 * Public: No
 */

params ["_control"];

private _isOn = ["getState", "radioOn"] call GUI_DATA_EVENT;
if (_isOn != 1) exitWith {};

//GVAR(backlightOn) = true;
//GVAR(lastAction) = time;
GVAR(displayButtonPressed) = true;

private _eh = _control ctrlAddEventHandler ["MouseButtonUp", {GVAR(displayButtonPressed) = false; [MAIN_DISPLAY] call FUNC(render);}];

[MAIN_DISPLAY] call FUNC(render);
