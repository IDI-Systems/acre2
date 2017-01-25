/*
 * Author: ACRE2Team
 * Sets the duplex of radio transmissions. If set to true, it means that you will receive transmissions even while talking and multiple people can speak at the same time.
 *
 * Arguments:
 * 0: Enable full duplex <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call acre_api_fnc_setFullDuplex;
 *
 * Public: Yes
 */
#include "script_component.hpp"

INFO_2("%1 called with: %2",QFUNC(setFullDuplex),_this);

if (!hasInterface) exitWith {false};

params ["_value"];

EGVAR(sys_core,fullDuplex) = _value;

INFO_5("Difficulty changed. Interference: %1 - Duplex: %2 - Terrain Loss: %3 - Omni-directional: %4 - AI Hearing: %5",EGVAR(sys_core,interference),EGVAR(sys_core,fullDuplex),EGVAR(sys_signal,terrainScaling),EGVAR(sys_signal,omnidirectionalRadios),EGVAR(sys_core,revealToAI));
