#include "script_component.hpp"
/*
 * Author: Tim Beswick
 * Sends configured channel name and server name to Mumble/TS plugin, triggering Mumble/TeamSpeak 3 channel move.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_io_fnc_voipChannelCheck
 *
 * Public: No
 */

private _channelDetails = format ["%1,%2,%3", EGVAR(sys_core,voipChannelName), EGVAR(sys_core,voipChannelPassword), serverName];
TRACE_1("Moving Mumble/TS3 Channel",_channelDetails);
CALL_RPC("setChannelDetails",_channelDetails);
