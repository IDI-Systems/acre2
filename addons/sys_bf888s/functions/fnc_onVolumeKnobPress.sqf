#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the event of turning the volume radio knob.
 *
 * Arguments:
 * 0: Unused <TYPE>
 * 1: Left or right mouse click identifier <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [["", 0], 0] call acre_sys_bf888s_fnc_onVolumeKnobPress
 *
 * Public: No
 */

params ["", "_key"];

private _currentDirection = -0.2;
if (_key == 0) then {
    // left click
    _currentDirection = 0.2;
};

private _currentVolume = GET_STATE("volume");
private _newVolume = ((_currentVolume + _currentDirection) max 0) min 1;

if (_currentVolume != _newVolume) then {
    ["Acre_GenericClick", [0, 0, 0], [0, 0, 0], _newVolume^3, false] call EFUNC(sys_sounds,playSound);
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
