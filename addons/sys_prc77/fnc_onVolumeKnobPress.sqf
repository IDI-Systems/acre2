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
 * [ARGUMENTS] call acre_sys_prc77_fnc_onVolumeKnobPress;
 *
 * Public: No
 */
#include "script_component.hpp"

private _key = _this select 1;
private _shift = _this select 4;

//Read out the key pressed (left/right mousebutton) and define the volume increase/decrease
private _dir = -1;
if(_key == 0) then {
    _dir = 1;
};

//If shift is pressed, perform a step by +-0.5
if(_shift) then {
_dir = _dir*5;
};

//Read out the currentVolume via DataEvent
private _currentVolume = GET_STATE("volume");
_currentVolume = _currentVolume * 10;

//Define and set new volume
private _newVolume = ((_currentVolume + _dir) max 0) min 10;
["setVolume", _newVolume*0.1] call CALLSTACK(GUI_DATA_EVENT);

//Play ClickSound and render dialog
["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
[MAIN_DISPLAY] call CALLSTACK(FUNC(render));
