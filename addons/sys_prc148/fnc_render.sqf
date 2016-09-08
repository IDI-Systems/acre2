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

uiNamespace setVariable [QUOTE(GVAR(currentDisplay)), _display];

SCRATCH_SET(GVAR(currentRadioId), "flashingText", []);
SCRATCH_SET(GVAR(currentRadioId), "animations", []);
[_display, ICON_BATSTRENGTH, false] call FUNC(showIcon);
[_display, ICON_BATTERY, false] call FUNC(showIcon);
[_display, ICON_SQUELCH, false] call FUNC(showIcon);
[_display, ICON_EXTERNAL, false] call FUNC(showIcon);
[_display, ICON_SIDECONNECTOR, false] call FUNC(showIcon);
[_display, 99212, false] call FUNC(showIcon); // cursor!

[_display, SMALL_LINE_1, [1,25], false] call FUNC(highlightText);
[_display, SMALL_LINE_2, [1,25], false] call FUNC(highlightText);
[_display, SMALL_LINE_3, [1,25], false] call FUNC(highlightText);
[_display, SMALL_LINE_4, [1,25], false] call FUNC(highlightText);
[_display, SMALL_LINE_5, [1,25], false] call FUNC(highlightText);

[_display, BIG_LINE_1, [1,18], false] call FUNC(highlightText);
[_display, BIG_LINE_2, [1,18], false] call FUNC(highlightText);
[_display, BIG_LINE_3, [1,18], false] call FUNC(highlightText);
[_display, BIG_LINE_4, [1,18], false] call FUNC(highlightText);

[_display, SMALL_LINE_1, "                         ", LEFT_ALIGN] call FUNC(displayLine);
[_display, SMALL_LINE_3, "                         ", LEFT_ALIGN] call FUNC(displayLine);
[_display, SMALL_LINE_2, "                         ", LEFT_ALIGN] call FUNC(displayLine);
[_display, SMALL_LINE_4, "                         ", LEFT_ALIGN] call FUNC(displayLine);
[_display, SMALL_LINE_5, "                         ", LEFT_ALIGN] call FUNC(displayLine);

[_display, BIG_LINE_1, "                  ", LEFT_ALIGN] call FUNC(displayLine);
[_display, BIG_LINE_2, "                  ", LEFT_ALIGN] call FUNC(displayLine);
[_display, BIG_LINE_3, "                  ", LEFT_ALIGN] call FUNC(displayLine);
[_display, BIG_LINE_4, "                  ", LEFT_ALIGN] call FUNC(displayLine);

private _currentVolume = GET_STATE(volume); //from 0 to 1
RADIO_CTRL(12010+201) ctrlSetTooltip format ["Current Volume: %1%2", round(_currentVolume * 100), "%"];

private _knobImageStr = format["\idi\acre\addons\sys_prc148\Data\knobs\volume\prc148_ui_vol_%1.paa", round(_currentVolume * 5)];
TRACE_1("VolumeKnob",_knobImageStr);
RADIO_CTRL(99903) ctrlSetText _knobImageStr;
RADIO_CTRL(99903) ctrlCommit 0;

private _currentChannel = GET_STATE(channelKnobPosition);
_knobImageStr = format["\idi\acre\addons\sys_prc148\Data\knobs\channel\prc148_ui_chan_%1.paa", _currentChannel];
RADIO_CTRL(99902) ctrlSetText _knobImageStr;
RADIO_CTRL(99902) ctrlCommit 0;



// acre_player sideChat format["off: %1", (["getOnOffState"] call GUI_DATA_EVENT)];
if((["getOnOffState"] call GUI_DATA_EVENT) > 0) then {
    private _currentState = ["getState", "currentState"] call GUI_DATA_EVENT;
    GVAR(currentState) = _currentState;
    [_display] call (missionNamespace getVariable [QUOTE(ADDON) + "_fnc_" + _currentState + "_Render", {}]);

    RADIO_CTRL(99911) ctrlSetFade 0.9;
    RADIO_CTRL(99911) ctrlCommit 0;

} else {
    RADIO_CTRL(99911) ctrlSetFade 0.5;
    RADIO_CTRL(99911) ctrlCommit 0
};
