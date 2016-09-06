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

private["_currentVolume", "_key", "_shift", "_dir", "_newVolume"];

_key = _this select 1;
_shift = _this select 4;

//Read out the key pressed (left/right mousebutton) and define the volume increase/decrease
_dir = -1;
if(_key == 0) then {
    _dir = 1;
};

//If shift is pressed, perform a step by +-0.5
if(_shift) then {
_dir = _dir*5;
};

//Read out the currentVolume via DataEvent
_currentVolume = GET_STATE(volume);
_currentVolume = _currentVolume * 10;

//Define and set new volume
_newVolume = ((_currentVolume + _dir) max 0) min 10;
["setVolume", _newVolume*0.1] call CALLSTACK(GUI_DATA_EVENT);

//Play ClickSound and render dialog
["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
[MAIN_DISPLAY] call CALLSTACK(FUNC(render));
