/*
 * Author: ACRE2Team
 * Sets the duplex of radio transmissions. If set to true, it means that you will receive transmissions even while talking and multiple people can speak at the same time.
 *
 * Arguments:
 * 0: True/false to set full duplex <BOOLEAN>
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

diag_log format["ACRE API: acre_api_fnc_setFullDuplex called with: %1", str _this];

params ["_value"];

ACRE_FULL_DUPLEX = _value;

diag_log format["ACRE API: Difficulty changed [Interference=%1, Duplex=%2, Terrain Loss=%3, Omnidrectional=%4, AI Hearing=%5]", str ACRE_INTERFERENCE, str ACRE_FULL_DUPLEX, str acre_sys_signal_terrainScaling, str acre_sys_signal_omnidirectionalRadios, str ACRE_AI_ENABLED];
