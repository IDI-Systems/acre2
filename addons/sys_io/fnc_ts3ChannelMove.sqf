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
 * [] call acre_sys_io_fnc_teamspeakChannelCheck
 *
 * Public: No
 */
#include "script_component.hpp"

private _ts3ChannelNames = format ["%1,%2", EGVAR(sys_core,ts3ChannelName), serverName];
TRACE_1("Moving TS3 Channel",_ts3ChannelNames);
CALL_RPC("setTs3ChannelNames",_ts3ChannelNames);
