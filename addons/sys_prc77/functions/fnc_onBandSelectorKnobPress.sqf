#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the event of turning the band selector radio knob: 32 to 50 MHz or 53-75 MHz.
 *
 * Arguments:
 * 0: Unused <ANY>
 * 1: Left or right click identifier <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["", 1] call acre_sys_prc77_fnc_onBandSelectorKnobPress
 *
 * Public: No
 */

params ["", "_key"];

//Read out the key pressed (left/right mousebutton) and define the knob position increase/decrease
private _dir = -1;
if (_key == 0) then {
    _dir = 1;
};

//Read out the current Band via DataEvent
private _currentBand = GET_STATE("band");
private _currentTuneKnobsPosition = GET_STATE("currentChannel");

//Define and set new knob position
private _newBand = ((_currentBand + _dir) max 0) min 1;
SET_STATE_CRIT("band", _newBand);

//The setCurrentChannel Event shall be triggered as well!
["setCurrentChannel", _currentTuneKnobsPosition] call CALLSTACK(GUI_DATA_EVENT);

//Play sound and render dialog
["Acre_GenericClick", [0, 0, 0], [0, 0, 0], 1, false] call EFUNC(sys_sounds,playSound);
[MAIN_DISPLAY] call CALLSTACK(FUNC(render));
