#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Renders the radio when opened.
 *
 * Arguments:
 * 0: Display identifier <NUMBER>
 *
 * Return Value:
 * True <BOOL>
 *
 * Example:
 * [DisplayID] call acre_sys_ws38_fnc_render
 *
 * Public: No
 */

#define RADIO_CTRL(var1) (_display displayCtrl var1)
#define IN 0
#define OUT 1

params ["_display"];

private _currentFunction = GET_STATE("function");
private _currentChannel = GET_STATE("currentChannel");
TRACE_2("Render", _currentFunction,_currentChannel);
RADIO_CTRL(106) ctrlSetText format ["\idi\acre\addons\sys_ws38\Data\knobs\mode\ws38_mode_%1.paa", _currentFunction];
RADIO_CTRL(107) ctrlSetText format ["\idi\acre\addons\sys_ws38\Data\dials\frequency\ws38_frequency_%1.paa", _currentChannel];
true
