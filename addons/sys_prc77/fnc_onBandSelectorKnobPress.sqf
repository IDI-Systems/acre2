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

private["_currentBand", "_key", "_dir", "_newBand", "_currentTuneKnobsPosition"];

_key = _this select 1;

//Read out the key pressed (left/right mousebutton) and define the knob position increase/decrease
_dir = -1;
if(_key == 0) then {
    _dir = 1;
};


//Read out the current Band via DataEvent
_currentBand = GET_STATE(band);
_currentTuneKnobsPosition = GET_STATE(currentChannel);

//Define and set new knob position
_newBand = ((_currentBand + _dir) max 0) min 1;
SET_STATE_CRIT(band, _newBand);

//The setCurrentChannel Event shall be triggered as well!
["setCurrentChannel", _currentTuneKnobsPosition] call CALLSTACK(GUI_DATA_EVENT);


//Play sound and render dialog
["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
[MAIN_DISPLAY] call CALLSTACK(FUNC(render));
