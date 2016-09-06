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

private ["_id", "_animations"];
_animations = SCRATCH_GET_DEF(GVAR(currentRadioId), "animations", []);
params["_func", "_args"];

_id = (count _animations);
_animations set[_id, [_args, _id, _func]];
