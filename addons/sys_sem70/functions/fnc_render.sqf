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
#define RADIO_CTRL(var1) (_display displayCtrl var1)

params["_display"];


private _channelKnobPosition = GET_STATE(channelKnobPosition);
private _volumeKnobPosition = GET_STATE(volumeKnobPosition);

// Volume knob

private _volImages = [
    QUOTE(PATHTOF(Data\knobs\volume\vol_1000.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\vol_0875.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\vol_0750.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\vol_0625.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\vol_0500.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\vol_0375.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\vol_0250.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\vol_0125.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\vol_0000.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\volsq_0125.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\volsq_0250.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\volsq_0375.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\volsq_0500.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\volsq_0625.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\volsq_0750.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\volsq_0875.paa)),
    QUOTE(PATHTOF(Data\knobs\volume\vol_1000.paa))
];
private _channelKnobPosition = GET_STATE(channelKnobPosition);
if (_channelKnobPosition == 15) then { //programming mode p
    // Wiggle the knob one state over depending on the selection Dir.
    _newIdx = _volumeKnobPosition + (-1 * GVAR(selectionDir)); // works the opposite way to the sorting.
    if (_newIdx > 16) then { _newIdx = 1; };
    if (_newIdx < 0) then {_newIdx = 15; };
    RADIO_CTRL(107) ctrlSetText (_volImages select _newIdx);
} else {
    RADIO_CTRL(107) ctrlSetText (_volImages select _volumeKnobPosition);
};

// Channel Switch

private _channelImages = [
    QUOTE(PATHTOF(Data\knobs\channel\ch_off.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_on.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_01.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_02.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_03.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_04.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_05.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_06.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_07.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_08.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_09.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_10.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_11.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_12.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_h.paa)),
    QUOTE(PATHTOF(Data\knobs\channel\ch_p.paa))
];

RADIO_CTRL(106) ctrlSetText (_channelImages select _channelKnobPosition);

// PPT Button

if (GVAR(depressedPTT)) then {
    RADIO_CTRL(108) ctrlSetText QUOTE(PATHTOF(Data\knobs\ptt_down.paa));
} else {
    RADIO_CTRL(108) ctrlSetText "";
};

// Audio headset cable

private _audioPath = GET_STATE(audioPath);

if (_audioPath == "HEADSET") then {
    RADIO_CTRL(300) ctrlSetText QUOTE(PATHTOF(Data\ui\sem70ui_headset_ca.paa));
} else {
    RADIO_CTRL(300) ctrlSetText QUOTE(PATHTOF(data\ui\sem70ui_ca.paa));
};

//display
[_display] call FUNC(renderDisplay);

TRACE_3("rendering", _currentChannel, _currentVolume, acre_sys_radio_currentRadioDialog);
true
