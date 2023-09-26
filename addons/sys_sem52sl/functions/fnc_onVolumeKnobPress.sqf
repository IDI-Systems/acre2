#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_sem52sl_fnc_onVolumeKnobPress
 *
 * Public: No
 */

//I am not using the API for getting the volume because that could
//be different from what the internal value is based on the speaker
//the API value should be used as a modifier coefficient, not as a
//state.
params ["","_key"];

GVAR(backlightOn) = true;
GVAR(lastAction) = time;


private _currentDirection = 1;
if (_key == 0) then {
    // left click
    _currentDirection = -1;
};

private _knobPosition = ["getState", "volumeKnobPosition"] call GUI_DATA_EVENT;

private _channelKnobPosition = ["getState", "channelKnobPosition"] call GUI_DATA_EVENT;

if (_channelKnobPosition == 15) then { // programming (used to help program).
    if (GVAR(selectionDir) == 0) then {
        GVAR(selectionDir) = -1 * _currentDirection;
    } else {
        GVAR(selectionDir) = 0;
    };

    ["Acre_SEMKnob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
} else { // Channel selected do Volume control
    private _newKnobPosition = ((_knobPosition + _currentDirection) max 0) min 16;

    if (_knobPosition != _newKnobPosition) then {

        ["setState", ["volumeKnobPosition",_newKnobPosition]] call GUI_DATA_EVENT;

        //private _currentVolume = GET_STATE("volume"); //["getState", "volume"] call GUI_DATA_EVENT;
        private _newVolume = abs ((_newKnobPosition - 8)/8);
        ["setVolume", _newVolume] call GUI_DATA_EVENT;

        ["Acre_SEMKnob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
    };
};
[MAIN_DISPLAY] call FUNC(render);
