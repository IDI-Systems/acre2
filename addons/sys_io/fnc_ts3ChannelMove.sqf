/*
 * Author: Tim Beswick
 * Checks if main display is visible and sets server name, triggering TeamSpeak 3 channel move.
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

TRACE_1("Moving TS3 Channel",serverName);
CALL_RPC("setServerName",serverName);
