#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the event of turning the channel radio knob or changing the block. It essentially sets a new channel as active
 * and plays the necessary sounds.
 *
 * Arguments:
 * 0: Array with the second entry identifying if it was a left or right click <ARRAY>
 * 1: Is changing block <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [["", 0], 0] call acre_sys_bf888s_fnc_onChannelKnobPress
 *
 * Public: No
 */

params ["_handlerarray", "_knob"];

private _key = _handlerarray select 1;

private _currentDirection = -1;
if (_key == 0) then {
    // left click
    _currentDirection = 1;
};

private _currentChannel =  [GVAR(currentRadioId)] call FUNC(getCurrentChannelInternal);

private _newChannel = _currentChannel;

if (_knob == 0) then {
    _newChannel = ((_currentChannel + _currentDirection) max 0) min 15;
};

TRACE_2("Channel", _newChannel, _currentChannel);
if (_newChannel != _currentChannel) then {
    ["setCurrentChannel", _newChannel] call GUI_DATA_EVENT;

    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
    [format ["Acre_Baofeng_%1",_newChannel + 1], [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call FUNC(render);
};
