//fnc_ignoreAntennaDirection.sqf
#include "script_component.hpp"

diag_log format["ACRE API: acre_api_fnc_ignoreAntennaDirection called with: %1", str _this];

params ["_value"];

// input boolean
if (_value) then {
    acre_sys_signal_omnidirectionalRadios = 1;
} else {
    acre_sys_signal_omnidirectionalRadios = 0;
};

diag_log format["ACRE API: Difficulty changed [Interference=%1, Duplex=%2, Terrain Loss=%3, Omnidrectional=%4, AI Hearing=%5]", str ACRE_INTERFERENCE, str ACRE_FULL_DUPLEX, str acre_sys_signal_terrainScaling, str acre_sys_signal_omnidirectionalRadios, str ACRE_AI_ENABLED];