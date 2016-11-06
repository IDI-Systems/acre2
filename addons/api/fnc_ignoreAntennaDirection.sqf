/*
 * Author: ACRE2Team
 * Use this to enable/disable the ignoring of antenna direction in the radio signal simulation.
 *
 * Arguments:
 * 0: ARGUMENT ONE <BOOLEAN>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_api_fnc_ignoreAntennaDirection;
 *
 * Public: Yes
 */
#include "script_component.hpp"

INFO_2("%1 called with: %2",QFUNC(ignoreAntennaDirection),_this);

if (!hasInterface) exitWith {false};

params ["_value"];

// input boolean
if (_value) then {
    acre_sys_signal_omnidirectionalRadios = 1;
} else {
    acre_sys_signal_omnidirectionalRadios = 0;
};

INFO_5("Difficulty changed. Interference: %1 - Duplex: %2 - Terrain Loss: %3 - Omni-directional: %4 - AI Hearing: %5",ACRE_INTERFERENCE,ACRE_FULL_DUPLEX,EGVAR(sys_signal,terrainScaling),EGVAR(sys_signal,omnidirectionalRadios),ACRE_AI_ENABLED);
