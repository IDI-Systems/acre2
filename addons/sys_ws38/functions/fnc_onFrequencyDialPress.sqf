#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the event of turning the frequency radio dial changing the frequencies the radio operates on and plays the necessary sounds.
 *
 * Arguments:
 * 0: Array with the second entry identifying if it was a left or right click <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [["", 0]] call acre_sys_ws38_fnc_onFrequencyDialPress
 *
 * Public: No
 */

params ["_handlerarray"];

private _key = _handlerarray select 1;

private _dir = -1;
if (_key == 0) then {
    // left click
    _dir = 1;
};

private _currentPosition = GET_STATE_DEF("channel",0);


if (_newAbsChannel != _currentAbsChannel) then {
    ["setCurrentChannel", _newAbsChannel] call GUI_DATA_EVENT;

    ["Acre_GenericClick", [0,0,0], [0,0,0], 1, false] call EFUNC(sys_sounds,playSound);
    [MAIN_DISPLAY] call FUNC(render);
};
