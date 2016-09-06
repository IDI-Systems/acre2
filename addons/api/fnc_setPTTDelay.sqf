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
params ["_var"];

if(!( _var isEqualType "SCALAR")) exitWith { false };

if(_var > 1 || _var < 0) exitWith { false };

ACRE_PTT_RELEASE_DELAY = _var;

true
