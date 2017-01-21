/*
 * Author: ACRE2Team
 * Use this to enable/disable the ignoring of antenna direction in the radio signal simulation.
 *
 * Arguments:
 * 0: Enable ignoring of antenna direction (omnidirectional radios) <BOOL>
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
EGVAR(sys_signal,omnidirectionalRadios) = parseNumber _value;

INFO_5("Difficulty changed. Interference: %1 - Duplex: %2 - Terrain Loss: %3 - Omni-directional: %4 - AI Hearing: %5",EGVAR(sys_core,interference),EGVAR(sys_core,fullDuplex),EGVAR(sys_signal,terrainScaling),EGVAR(sys_signal,omnidirectionalRadios),EGVAR(sys_core,revealToAI));
