/*
 * Author: AUTHOR
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

diag_log format["ACRE API: acre_api_fnc_setRevealToAI called with: %1", str _this];

params["_var"];

//if(!isServer) exitWith {
//    hint "ACRE WARNING: acre_api_fnc_setRevealToAI is server-side only";
//    diag_log text format["ACRE WARNING: acre_api_fnc_setRevealToAI is server-side only"];
//};

if(!(_var isEqualType false)) exitWith { false };


if( !ACRE_AI_ENABLED && _var ) then {
    [] call acre_sys_core_fnc_enableRevealAI;
} else {
    if( ACRE_AI_ENABLED && !_var ) then {
        [] call acre_sys_core_fnc_disableRevealAI;
    };
};

ACRE_AI_ENABLED = _var;

diag_log format["ACRE API: Difficulty changed [Interference=%1, Duplex=%2, Terrain Loss=%3, Omnidrectional=%4, AI Hearing=%5]", str ACRE_INTERFERENCE, str ACRE_FULL_DUPLEX, str acre_sys_signal_terrainScaling, str acre_sys_signal_omnidirectionalRadios, str ACRE_AI_ENABLED];

_var
