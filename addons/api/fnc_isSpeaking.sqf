#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks whether the provided unit is currently speaking, either on radio or direct.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Is unit speaking <BOOLEAN>
 *
 * Example:
 * _isSpeaking = [player] call acre_api_fnc_isSpeaking;
 *
 * Public: Yes
 */

params [
    ["_unit", objNull, [objNull]]
];


_unit in EGVAR(sys_core,speakers)
