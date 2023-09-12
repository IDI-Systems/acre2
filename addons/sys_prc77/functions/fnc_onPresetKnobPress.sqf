#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Loads or saves a preset when pressing the Preset buttons on a PRC77.
 *
 * Arguments:
 * 0: Array with the second entry identifying if it was a left or right click <ARRAY>
 * 1: Preset array <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [["", 0], 0] call acre_sys_prc77_fnc_onPresetKnobPress
 *
 * Public: No
 */

params ["_handlerarray", "_preset"];

private _key = _handlerarray select 1;

private _fnc = 1; //0 = Load; 1 = Save
// Read out the current KnobPositions via DataEvent | need to make a full copy of the array
if (_key == 0) then {
    _fnc = 0;
};

// Select Presetarray
// Get the full Preset array [[x,y],[u,v]]
private _currentPresets = GET_STATE("currentPreset");


if (_fnc == 0) then {
    // Select array according to preset handler (left,right) [x,y]
    private _currentPreset = _currentPresets select _preset;
    // Copy the new presetarray to the knobs position [x,y]
    private _newTuneKnobsPosition = + _currentPreset;
    // Set the tuneknobsposition
    ["setCurrentChannel", _newTuneKnobsPosition] call CALLSTACK(GUI_DATA_EVENT);

    // Change the image and play click sound
    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call CALLSTACK(FUNC(render));
} else {
    // Read out current TuneKnobsPosition
    private _currentTuneKnobsPosition = GET_STATE("currentChannel");
    // Define new preset
    private _newPreset = + _currentTuneKnobsPosition;
    // Write in the presets array
    private _newPresets = + _currentPresets;
    (_newPresets select _preset) set [0, _newPreset select 0];
    (_newPresets select _preset) set [1, _newPreset select 1];
    SET_STATE("currentPreset", _newPresets);

    // Change the image and play click sound
    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
};
