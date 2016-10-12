/*
 * Author: ACRE2Team
 * Sets whether transmissions will interfere with each other. This, by default, causes signal loss when multiple people are transmitting on the same frequency.
 *
 * Arguments:
 * 0: True/false to set interference. <BOOLEAN>
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

params ["_value"];

ACRE_INTERFERENCE = _value;

INFO_5("Difficulty changed. Interference: %1 - Duplex: %2 - Terrain Loss: %3 - Omni-directional: %4 - AI Hearing: %5",ACRE_INTERFERENCE,ACRE_FULL_DUPLEX,EGVAR(sys_signal,terrainScaling),EGVAR(sys_signal,omnidirectionalRadios),ACRE_AI_ENABLED);
