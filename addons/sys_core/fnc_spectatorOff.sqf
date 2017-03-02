/*
 * Author: ACRE2Team
 * Disables spectator mode on the local player.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_core_fnc_spectatorOff
 *
 * Public: No
 */
#include "script_component.hpp"

ACRE_IS_SPECTATOR = false;
[QEGVAR(sys_server,onSetSpector), [GVAR(ts3id), 0] ] call CALLSTACK(CBA_fnc_serverEvent);
true
