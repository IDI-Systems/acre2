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
 * [DisplayID] call acre_sys_prc77_fnc_render
 *
 * Public: No
 */

#define RADIO_CTRL(var1) (_display displayCtrl var1)
params ["_display"];

//Set Volumeknob position
private _currentVolume = GET_STATE("volume");
_currentVolume = _currentVolume*10;
RADIO_CTRL(108) ctrlSetText format ["\idi\acre\addons\sys_prc77\Data\images\volume\prc77_volume_%1.paa", _currentVolume];

//Set Functionknob position
private _currentFunction = GET_STATE("function");
RADIO_CTRL(105) ctrlSetText format ["\idi\acre\addons\sys_prc77\Data\images\function\prc77_function_%1.paa", _currentFunction];

//Set Bandknob position
private _currentBand = GET_STATE("band");
RADIO_CTRL(109) ctrlSetText format ["\idi\acre\addons\sys_prc77\Data\images\band\PRC77_bandselector_%1.paa", _currentBand];
RADIO_CTRL(204) ctrlSetText format ["\idi\acre\addons\sys_prc77\Data\images\dials\PRC77_display_%1.paa", _currentBand];

//Set TuneKnobs position
private _currentTuneKnob = GET_STATE("currentChannel");
RADIO_CTRL(202) ctrlSetText format ["\idi\acre\addons\sys_prc77\Data\images\dials\prc77_ui_disc_MHz_%1%2.paa", _currentBand + 1, [_currentTuneKnob select 0,2] call CBA_fnc_formatNumber];
RADIO_CTRL(203) ctrlSetText format ["\idi\acre\addons\sys_prc77\Data\images\dials\prc77_ui_disc_KHz_%1.paa", [(_currentTuneKnob select 1),2] call CBA_fnc_formatNumber ];

RADIO_CTRL(2021) ctrlSetText format ["\idi\acre\addons\sys_prc77\Data\images\knob\prc77_ui_knob_MHz_%1.paa", _currentTuneKnob select 0];
RADIO_CTRL(2031) ctrlSetText format ["\idi\acre\addons\sys_prc77\Data\images\knob\prc77_ui_knob_KHz_%1.paa", _currentTuneKnob select 1];


true
