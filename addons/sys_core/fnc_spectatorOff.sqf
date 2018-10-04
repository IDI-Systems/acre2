#include "script_component.hpp"
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

ACRE_IS_SPECTATOR = false;
[QEGVAR(sys_server,onSetSpector), [GVAR(ts3id), 0, clientOwner] ] call CALLSTACK(CBA_fnc_serverEvent);
true
