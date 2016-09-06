/*
 * Author: AUTHOR
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

private["_key", "_shift", "_dir", "_currentTuneKnobsPosition", "_currentMHzKnobPosition", "_newMHzKnobPosition", "_newTuneKnobsPosition"];

_key = _this select 1;
_shift = _this select 4;

//Read out the key pressed (left/right mousebutton) and define the knob position increase/decrease
_dir = -1;
if(_key == 0) then {
    _dir = 1;
};

//If shift is pressed, perform a step by +-5
if(_shift) then {
_dir = _dir*5;
};

//Read out the current KnobPositions via DataEvent | need to make a full copy of the array
_currentTuneKnobsPosition = [];
_currentTuneKnobsPosition = GET_STATE(currentChannel);
_currentMHzKnobPosition = _currentTuneKnobsPosition select 0;

//Define and set new knob position
_newMHzKnobPosition = _currentMHzKnobPosition + _dir;
//Allow a jump over the null position
if (_newMHzKnobPosition > 22) then {
    _newMHzKnobPosition = 0;
};
if (_newMHzKnobPosition < 0) then {
    _newMHzKnobPosition = 22;
};


_newTuneKnobsPosition = + _currentTuneKnobsPosition;
_newTuneKnobsPosition set [0, _newMHzKnobPosition];
["setCurrentChannel", _newTuneKnobsPosition] call CALLSTACK(GUI_DATA_EVENT);

//Change the image and play click sound
["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
[MAIN_DISPLAY] call CALLSTACK(FUNC(render));
