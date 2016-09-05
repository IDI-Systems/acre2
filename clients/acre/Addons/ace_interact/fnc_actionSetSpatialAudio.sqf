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