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

private ["_return"];
params ["_id"];

if(IS_STRING(_id)) then {
    _id = parseNumber _id;
};
_return = nil;

{
    if ((_x select 0) == _id) exitWith { _return = _x select 1; };
} forEach (GVAR(playerList));

_return;
