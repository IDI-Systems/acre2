#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_data_fnc_addHighPriorityId
 *
 * Public: No
 */

params ["_id"];

if (_id in GVAR(forceHighPriorityIds)) exitWith {};

private _found = false;
for "_i" from 0 to (count GVAR(forceHighPriorityIds))-1 do {
    private _checkId = GVAR(forceHighPriorityIds) select _i;
    if (isNil "_checkId") exitWith {
        GVAR(forceHighPriorityIds) set [_i, _id];
        _found = true;
    };
};

if (!_found) then {
    PUSH(GVAR(forceHighPriorityIds),_id);
};
