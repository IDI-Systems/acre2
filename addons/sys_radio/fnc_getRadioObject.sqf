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

params ["_class"];

private _ret = nil;
if (HASH_HASKEY(acre_sys_server_objectIdRelationTable, _class)) then {
    _ret = (HASH_GET(acre_sys_server_objectIdRelationTable, _class) select 0);
};
_ret;
