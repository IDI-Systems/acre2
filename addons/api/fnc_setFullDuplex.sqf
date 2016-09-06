/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

 
#include "script_component.hpp"

diag_log format["ACRE API: acre_api_fnc_setFullDuplex called with: %1", str _this];

params ["_value"];

ACRE_FULL_DUPLEX = _value;

diag_log format["ACRE API: Difficulty changed [Interference=%1, Duplex=%2, Terrain Loss=%3, Omnidrectional=%4, AI Hearing=%5]", str ACRE_INTERFERENCE, str ACRE_FULL_DUPLEX, str acre_sys_signal_terrainScaling, str acre_sys_signal_omnidirectionalRadios, str ACRE_AI_ENABLED];
