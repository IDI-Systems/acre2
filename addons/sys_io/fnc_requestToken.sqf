#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Asks the server for a voice server join token. The server identifies the caller itself
 * (remoteExecutedOwner), so a client can only ever get a token for its own player.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_io_fnc_requestToken
 *
 * Public: No
 */

GVAR(lastTokenRequest) = diag_tickTime;
TRACE_1("requesting voice token",clientOwner);
[] remoteExecCall [QEFUNC(sys_server,requestVoiceToken), 2];
