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

private _currentMode = GET_STATE_DEF("mode_knob",0);
RADIO_CTRL(106) ctrlSetText format ["\idi\acre\addons\sys_ws38\Data\knobs\mode\ws38_mode_%1.paa", _currentMode];
true
