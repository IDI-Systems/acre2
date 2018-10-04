#include "script_component.hpp"
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
 * [0.5] call acre_sys_core_fnc_setLossModelScale
 *
 * Public: No
 */

if (!hasInterface) exitWith {false};

params ["_scale"];

// Set
_scale = _scale max 0;
EGVAR(sys_signal,terrainScaling) = _scale;

_scale
