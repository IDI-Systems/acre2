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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

//I am not using the API for getting the volume because that could
//be different from what the internal value is based on the speaker
//the API value should be used as a modifier coefficient, not as a
//state.
params ["","_key"];

private _currentDirection = -0.2;
if (_key == 0) then {
    // left click
    _currentDirection = 0.2;
};

private _currentVolume = GET_STATE("volume"); //["getState", "volume"] call GUI_DATA_EVENT;
private _newVolume = ((_currentVolume + _currentDirection) max 0) min 1;

if (_currentVolume != _newVolume) then {
    ["Acre_GenericClick", [0,0,0], [0,0,0], _newVolume^3, false] call EFUNC(sys_sounds,playSound);
    ["setVolume", _newVolume] call GUI_DATA_EVENT;


    [MAIN_DISPLAY] call FUNC(render);

    if (_newVolume < 0.2) then {
        ["setOnOffState", 0] call GUI_DATA_EVENT;
    } else {
        if (_newVolume > 0 && _currentVolume < 0.2) then {
            ["setOnOffState", 1] call GUI_DATA_EVENT;
        };
    };
};
