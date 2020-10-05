#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles stopping the radio gesture
 *
 * Arguments:
 * 0: Unit to stop gesture <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_player] call acre_sys_gesture_fnc_stopGesture
 *
 * Public: No
 */

params ["_unit"];

if (_unit getVariable [QGVAR(onRadio), false]) then {
    _unit playActionNow "acre_radio_stop";
    _unit setVariable [QGVAR(onRadio), false];
};
