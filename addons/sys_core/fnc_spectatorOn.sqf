/*
 * Author: ACRE2Team
 * Enables spectator mode on the local player.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_core_fnc_spectatorOn
 *
 * Public: No
 */
#include "script_component.hpp"

ACRE_IS_SPECTATOR = true;
[QEGVAR(sys_server,onSetSpector), [GVAR(ts3id), 1] ] call CALLSTACK(CBA_fnc_serverEvent);
true
