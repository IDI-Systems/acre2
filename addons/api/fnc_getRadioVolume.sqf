/*
 * Author: ACRE2Team
 * Gets the volume for the given radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * Volume value between 0 and 1 <Number>
 *
 * Example:
 * [ARGUMENTS] call acre_api_fnc_getRadioVolume
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_radioId"];

[_radioId] call EFUNC(sys_radio,getRadioVolume);
