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
 * [ARGUMENTS] call acre_sys_sem70_fnc_onMainKnobTurn
 *
 * Public: No
 */

params ["","_key"];

GVAR(backlightOn) = true;
GVAR(lastAction) = time;

private _currentDirection = -1;
if (_key == 0) then {
    // left click
    _currentDirection = 1;
};

private _knobPosition = ["getState", "mainKnobPosition"] call GUI_DATA_EVENT;
private _newKnobPosition = ((_knobPosition + _currentDirection) max 0) min 2;

if (_knobPosition != _newKnobPosition) then {
    ["setState", ["mainKnobPosition",_newKnobPosition]] call GUI_DATA_EVENT;

    switch _newKnobPosition do {
        //cases (insertable by snippet)
        case 0: {
            // Turn off
            [GVAR(currentRadioId), "setOnOffState", 0] call EFUNC(sys_data,dataEvent);
            GVAR(backlightOn) = false; // turn backlight off.
        };

        default {
            private _isOn = ["getState", "radioOn"] call GUI_DATA_EVENT;

            [GVAR(currentRadioId), "setOnOffState", 1] call EFUNC(sys_data,dataEvent);

            if (_newKnobPosition == 1) then {
                SET_STATE("power",400);
            };

            if (_newKnobPosition == 2) then {
                SET_STATE("power",4000);
            };
        };
    };

    ["Acre_SEMKnob", [0,0,0], [0,0,0], 0.3, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call FUNC(render);
};
