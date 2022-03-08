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

private _ts3ChannelDetails = format ["%1,%2,%3", EGVAR(sys_core,ts3ChannelName), EGVAR(sys_core,ts3ChannelPassword), serverName];
TRACE_1("Moving TS3 Channel",_ts3ChannelDetails);
["setTs3ChannelDetails",_ts3ChannelDetails] call EFUNC(sys_rpc,callRemoteProcedure);
