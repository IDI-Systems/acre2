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

private["_key", "_fnc", "_currentPresets"];

params["_handlerarray", "_preset"];

_key = _handlerarray select 1;

_fnc = 1; //0=Load; 1=Save
//Read out the current KnobPositions via DataEvent | need to make a full copy of the array
if(_key == 0) then {
    _fnc = 0;
};

//Select Presetarray
//Get the full Preset array [[x,y],[u,v]]
_currentPresets = GET_STATE(currentPreset);


if(_fnc == 0) exitWith {

private["_currentPreset", "_newTuneKnobsPosition"];
//Select array according to preset handler (left,right) [x,y]
_currentPreset = _currentPresets select _preset;
//Copy the new presetarray to the knobs position [x,y]
_newTuneKnobsPosition = + _currentPreset;
//Set the tuneknobsposition
["setCurrentChannel", _newTuneKnobsPosition] call CALLSTACK(GUI_DATA_EVENT);

//Change the image and play click sound
["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
[MAIN_DISPLAY] call CALLSTACK(FUNC(render));
};


if(_fnc == 1) exitWith {
private["_currentTuneKnobsPosition", "_newPreset", "_newPresets"];
//Read out current TuneKnobsPosition
_currentTuneKnobsPosition = GET_STATE(currentChannel);
//Define new preset
_newPreset = + _currentTuneKnobsPosition;
//Write in the presets array
_newPresets = + _currentPresets;
(_newPresets select _preset) set [0, _newPreset select 0];
(_newPresets select _preset) set [1, _newPreset select 1];
SET_STATE(currentPreset, _newPresets);

//Change the image and play click sound
["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
};
