/*
 * Author: ACRE2Team
 * Setting it to 0 means the terrain loss model is disabled, 1 is default. Note this setting only effects loss caused by terrain, loss due to power dissipation over range will always occur.
 *
 * Arguments:
 * 0: Terrain loss scale. Value between 0 and 1. <NUMBER>
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

diag_log format["ACRE API: acre_api_fnc_setLossModelScale called with: %1", str _this];

params ["_scale"];

_scale = _scale max 0;

acre_sys_signal_terrainScaling = _scale;

diag_log format["ACRE API: Difficulty changed [Interference=%1, Duplex=%2, Terrain Loss=%3, Omnidrectional=%4, AI Hearing=%5]", str ACRE_INTERFERENCE, str ACRE_FULL_DUPLEX, str acre_sys_signal_terrainScaling, str acre_sys_signal_omnidirectionalRadios, str ACRE_AI_ENABLED];

_scale
