#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks the unit isn't on radio and mid-reload then stops the gesture.
 *
 * Arguments:
 * 0: Unit that stopped speaking <OBJECT>
 * 1: Was unit on radio <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_player,false] call acre_sys_gesture_fnc_stoppedSpeaking
 *
 * Public: No
 */

params ["_unit", "_onRadio"];

if (!_onRadio) exitWith {};

// If the unit started a reload while already talking, need to wait to finish to not delete a magazine
[
    {!ace_common_isReloading},
    {
        // Wait 1 frame as mag doesn't report as loaded til events completed
        [FUNC(stopGesture), _this] call CBA_fnc_execNextFrame;
    },
    _unit
] call CBA_fnc_waitUntilAndExecute;
