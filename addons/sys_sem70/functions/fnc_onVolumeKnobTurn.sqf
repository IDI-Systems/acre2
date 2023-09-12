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
 * [ARGUMENTS] call acre_sys_sem70_fnc_onVolumeKnobTurn
 *
 * Public: No
 */

params ["","_key"];

private _currentDirection = -1;
if (_key == 0) then {
    // left click
    _currentDirection = 1;
};

private _knobPosition = ["getState", "volumeKnobPosition"] call GUI_DATA_EVENT;

// Channel selected do Volume control
private _newKnobPosition = ((_knobPosition + _currentDirection) max 0) min 5;

if (_knobPosition != _newKnobPosition) then {

    ["setState", ["volumeKnobPosition",_newKnobPosition]] call GUI_DATA_EVENT;

    //private _currentVolume = GET_STATE("volume"); //["getState", "volume"] call GUI_DATA_EVENT;
    private _newVolume = abs ((_newKnobPosition)/5);
    ["setVolume", _newVolume] call GUI_DATA_EVENT;

    ["Acre_SEMKnob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
};

[MAIN_DISPLAY] call FUNC(render);
