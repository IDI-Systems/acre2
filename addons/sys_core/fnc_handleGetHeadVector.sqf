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

// return the head vector of the current acre_player, or 0,0,0 if no vector
private _vector = [] call FUNC(getHeadVector);
private _vectorStr = format["%1,%2,%3,", (_vector select 0), (_vector select 1),(_vector select 2)];
CALL_RPC("setHeadVector", _vectorStr);

true
