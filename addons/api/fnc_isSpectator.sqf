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

params[["_unit",acre_player]];

if(_unit == acre_player) exitWith {
    ACRE_IS_SPECTATOR
};

if( _unit in ACRE_SPECTATORS_LIST) exitWith {
    true
};

_spectVariable
