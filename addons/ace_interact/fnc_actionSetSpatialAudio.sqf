/*
 * Author: AUTHOR
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

params ["_target","_player","_params","_desiredEar"];
_params params ["_radio"];

if (_desiredEar == 0) then {
    [_radio,"LEFT"] call acre_api_fnc_setRadioSpatial;
};
if (_desiredEar == 1) then {
    [_radio,"RIGHT"] call acre_api_fnc_setRadioSpatial;
};
if (_desiredEar == 2) then {
    [_radio,"CENTER"] call acre_api_fnc_setRadioSpatial;
};
