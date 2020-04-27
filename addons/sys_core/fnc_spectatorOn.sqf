#include "script_component.hpp"
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

if (!ACRE_IS_SPECTATOR) then {
    ACRE_IS_SPECTATOR = true;
    [QEGVAR(sys_server,onSetSpector), [GVAR(ts3id), 1, clientOwner]] call CALLSTACK(CBA_fnc_serverEvent);
    TRACE_1("spectatorOn",ACRE_IS_SPECTATOR);
};

true
