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

params ["_radioId", "_id", "_value"];

if (!HASH_HASKEY(GVAR(radioScratchData), _radioId)) then {
    HASH_SET(GVAR(radioScratchData), _radioId, HASH_CREATE);
};

private _data = HASH_GET(GVAR(radioScratchData), _radioId);
HASH_SET(_data, _id, _value);

true
