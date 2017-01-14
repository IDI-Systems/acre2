/*
 * Author: ACRE2Team
 * Disables spectator mode on the local player.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOLEAN>
 *
 * Example:
 * [] call acre_sys_core_fnc_spectatorOff
 *
 * Public: No
 */
#include "script_component.hpp"

ACRE_IS_SPECTATOR = false;
["acre_sys_server_onSetSpector", [GVAR(ts3id), 0] ] call CALLSTACK(CBA_fnc_globalEvent);
true
