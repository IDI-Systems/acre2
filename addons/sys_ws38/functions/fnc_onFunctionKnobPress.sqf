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

private _currentMode = GET_STATE_DEF("function",0);
private _newMode = ((_currentMode + _dir) max 0) min 2;
TRACE_2("Changing mode",_currentMode, _newMode);

if(_newMode != _currentMode) then {
    SET_STATE("function", _newMode);

    if((_newMode == 0 || _newMode == 1) && _currentMode != 2) then {
        ["setOnOffState", _newMode] call GUI_DATA_EVENT;
    };

    if(_newMode == 2) then {
        _mpttRadioList = [] call  EFUNC(api,getMultiPushToTalkAssignment);
        _index = _mpttRadioList find GVAR(currentRadioId);
        if(_index != -1) then {
            [_index] call EFUNC(sys_core,handleMultiPttKeyPress);
        };
    };

    if(_newMode == 1 && _currentMode == 2) then {
        _mpttRadioList = [] call  EFUNC(api,getMultiPushToTalkAssignment);
        _index = _mpttRadioList find GVAR(currentRadioId);
        if(_index != -1) then {
            [_index] call EFUNC(sys_core,handleMultiPttKeyPressUp);
        };
    };
    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
    [QGVAR(uiStateChanged), []] call CBA_fnc_localEvent;
    //[MAIN_DISPLAY] call FUNC(render);
};
