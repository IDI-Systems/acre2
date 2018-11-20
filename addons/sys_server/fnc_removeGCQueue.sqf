#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Remove the specified radio from the GC queue. This is typically called when a client no longer has a desynced radio to reset its GC status.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc152_id_1"] call acre_sys_server_fnc_removeGCQueue
 *
 * Public: No
 */

params ["_radioId"];

// Removes entry in markedForGC to restart the GC process should another desynced player later use it.
HASH_REM(GVAR(markedForGC),_radioId);
