/*
 * Author: ACRE2Team
 * Setting it to 0 means the terrain loss model is disabled, 1 is default. Note this setting only effects loss caused by terrain, loss due to power dissipation over range will always occur.
 *
 * Arguments:
 * 0: Terrain loss scale (value between 0 and 1) <NUMBER>
 *
 * Return Value:
 * Terrain loss scale <NUMBER>
 *
 * Example:
 * [0.5] call acre_api_fnc_setLossModelScale
 *
 * Public: Yes
 */
#include "script_component.hpp"

INFO_2("%1 called with: %2",QFUNC(setLossModelScale),_this);

if (!hasInterface) exitWith {false};

params ["_scale"];

_scale = _scale max 0;

EGVAR(sys_signal,terrainScaling) = _scale;

INFO_5("Difficulty changed. Interference: %1 - Duplex: %2 - Terrain Loss: %3 - Omni-directional: %4 - AI Hearing: %5",EGVAR(sys_core,interference),EGVAR(sys_core,fullDuplex),EGVAR(sys_signal,terrainScaling),EGVAR(sys_signal,omnidirectionalRadios),EGVAR(sys_core,revealToAI));

_scale
