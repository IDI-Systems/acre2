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
 * [ARGUMENTS] call acre_sys_data_fnc_removeHighPriorityId
 *
 * Public: No
 */

params ["_id"];

private _index = GVAR(forceHighPriorityIds) find _id;
if (_index != -1) then {
    GVAR(forceHighPriorityIds) set [_index, nil];
};
