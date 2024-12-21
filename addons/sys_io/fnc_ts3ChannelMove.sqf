#include "script_component.hpp"
/*
 * Author: Tim Beswick
 * Sends configured channel name and server name to TS plugin, triggering TeamSpeak 3 channel move.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_io_fnc_ts3ChannelMove
 *
 * Public: No
 */

private _serverName = toString ((toArray serverName) select {_x < 127});
if (_serverName == "") then {
    _serverName = "Unsupported Server Name";
    if (!isMultiplayer) exitWith {};
    WARNING_1("Server name '%1' did not include any valid (ASCII) characters and got fully sanitized!",serverName)
};
private _ts3ChannelDetails = format ["%1,%2,%3", EGVAR(sys_core,ts3ChannelName), EGVAR(sys_core,ts3ChannelPassword), _serverName];
TRACE_1("Moving TS3 Channel",_ts3ChannelDetails);
["setTs3ChannelDetails",_ts3ChannelDetails] call EFUNC(sys_rpc,callRemoteProcedure);
