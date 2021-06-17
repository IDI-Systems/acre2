#include "script_component.hpp"
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
 * [DisplayID] call acre_sys_bf888s_fnc_render
 *
 * Public: No
 */

#define RADIO_CTRL(var1) (_display displayCtrl var1)


params ["_display"];

private _currentAbsChannel = [GVAR(currentRadioId)] call FUNC(getCurrentChannelInternal);
private _currentChannel = _currentAbsChannel;


//private _currentChannelKnobState = _currentChannelArray select 0; //channel from 0 to 15
private _currentVolume = GET_STATE("volume"); //from 0 to 1
private _currentVolumeKnobState = round (_currentVolume * 5);

{_x ctrlEnable false;} forEach [RADIO_CTRL(201), RADIO_CTRL(202)];

private _currentViewFrame = 0;
_currentViewFrame = 0;

{
    (RADIO_CTRL(_x)) ctrlSetFade 0;
    (RADIO_CTRL(_x)) ctrlCommit 0;
} forEach [106,107];

RADIO_CTRL(106) ctrlSetText format ["\idi\acre\addons\sys_bf888s\Data\knobs\channel\bf888s_ui_pre_%1.paa", _currentChannel + 1];
RADIO_CTRL(107) ctrlSetText format ["\idi\acre\addons\sys_bf888s\Data\knobs\volume\bf888s_ui_vol_%1.paa", _currentVolumeKnobState];
RADIO_CTRL(202) ctrlSetTooltip format ["Current Volume: %1%2", round (_currentVolume * 100), "%"];
RADIO_CTRL(99999) ctrlSetText QPATHTOF(Data\static\bf888s_ui_backplate.paa);

{_x ctrlEnable true;} forEach [RADIO_CTRL(201), RADIO_CTRL(202)];

TRACE_3("rendering", _currentChannel, _currentVolume, EGVAR(sys_radio,currentRadioDialog));
true
