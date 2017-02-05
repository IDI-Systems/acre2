/*
 * Author: ACRE2Team
 * Sends the current head direction vector to the TeamSpeak plugin.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_core_fnc_handleGetHeadVector
 *
 * Public: No
 */
#include "script_component.hpp"

// return the head vector of the current acre_player, or 0,0,0 if no vector
private _vector = [] call FUNC(getHeadVector);
private _vectorStr = format["%1,%2,%3,", (_vector select 0), (_vector select 1),(_vector select 2)];
CALL_RPC("setHeadVector", _vectorStr);

true
