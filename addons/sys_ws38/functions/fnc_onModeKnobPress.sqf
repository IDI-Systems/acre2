#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the event of turning the mode radio knob. To enable or disable the radio
 * and plays the necessary sounds.
 *
 * Arguments:
 * 0: Array with the second entry identifying if it was a left or right click <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[""], 0] call acre_sys_ws38_fnc_onChannelKnobPress
 *
 * Public: No
 */

params ["_control", "_key"];

private _dir = -1;
if (_key == 0) then {
    // left click
    _dir = 1;
};

private _currentMode = GET_STATE_DEF("mode_knob",0);
private _newMode = ((_currentMode + _dir) max 0) min 1;
TRACE_2("Changing mode",_currentMode, _newMode);

if(_newMode != _currentMode) then {
    SET_STATE("mode_knob", _newMode);
    ["setOnOffState", _newMode] call GUI_DATA_EVENT;
    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call FUNC(render);
};
