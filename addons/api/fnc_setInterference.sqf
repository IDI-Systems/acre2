/*
 * Author: ACRE2Team
 * Sets whether transmissions will interfere with each other. This, by default, causes signal loss when multiple people are transmitting on the same frequency.
 *
 * Arguments:
 * 0: Enable interference <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_api_fnc_setInterference;
 *
 * Public: Yes
 */
#include "script_component.hpp"

INFO_2("%1 called with: %2",QFUNC(setInterference),_this);

if (!hasInterface) exitWith {false};

params ["_value"];

EGVAR(sys_core,interference) = _value;

INFO_5("Difficulty changed. Interference: %1 - Duplex: %2 - Terrain Loss: %3 - Omni-directional: %4 - AI Hearing: %5",EGVAR(sys_core,interference),EGVAR(sys_core,fullDuplex),EGVAR(sys_signal,terrainScaling),EGVAR(sys_signal,omnidirectionalRadios),EGVAR(sys_core,revealToAI));
