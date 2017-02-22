/*
 * Author: Tim Beswick
 * Checks if main display is visible and sets server name, triggering teamspeak channel move.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_server_fnc_teamspeakChannelCheck
 *
 * Public: No
 */
#include "script_component.hpp"

[{
    params ["", "_idPFH"];

    if (EGVAR(sys_io,serverStarted) && {!(isNull (findDisplay 46))}) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        ["setServerName", [serverName]] call EFUNC(sys_rpc,callRemoteProcedure);
    };
}, 5, []] call CALLSTACK(CBA_fnc_addPerFrameHandler);
