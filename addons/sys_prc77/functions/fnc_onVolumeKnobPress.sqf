#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the event of turning the volume radio knob.
 *
 * Arguments:
 * 0: Unused <ANY>
 * 1: Left or right click identifier <NUMBER>
 * 2: Unused <ANY>
 * 3: Unused <ANY>
 * 4: Is shift pressed <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["", 1, "", "", true] call acre_sys_prc77_fnc_onVolumeKnobPress
 *
 * Public: No
 */

params ["", "_key", "", "", "_shift"];

//Read out the key pressed (left/right mousebutton) and define the volume increase/decrease
private _dir = -1;
if (_key == 0) then {
    _dir = 1;
};

// If shift is pressed, perform a step by +-0.5
if (_shift) then {
    _dir = _dir*5;
};

// Read out the currentVolume via DataEvent
private _currentVolume = GET_STATE("volume");
_currentVolume = _currentVolume * 10;

// Define and set new volume
private _newVolume = ((_currentVolume + _dir) max 0) min 10;
["setVolume", _newVolume*0.1] call CALLSTACK(GUI_DATA_EVENT);

// Play ClickSound and render dialog
["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
[MAIN_DISPLAY] call CALLSTACK(FUNC(render));
