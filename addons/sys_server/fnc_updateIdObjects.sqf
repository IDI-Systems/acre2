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

private _update = _this;
if(ACRE_DATA_SYNCED) then {
    {
        HASH_SET(GVAR(objectIdRelationTable), _x select 0, _x select 1);
    } forEach _update;
} else {
    PUSH(GVAR(pendingIdRelationUpdates), _update);
};
