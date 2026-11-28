#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * A client asks for a voice server join token (via remoteExecCall). The caller is identified
 * from remoteExecutedOwner, never from arguments, so nobody can get someone else's token.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] remoteExecCall ["acre_sys_server_fnc_requestVoiceToken", 2]
 *
 * Public: No
 */

if (!isServer) exitWith {};

private _owner = remoteExecutedOwner;
if (_owner == 0) exitWith {};

private _user = (allUsers apply {getUserInfo _x}) select {(_x select 1) == _owner};
if (_user isEqualTo []) exitWith {
    WARNING_1("Voice token requested by unknown client %1",_owner);
};
private _uid = (_user select 0) select 2;

if (!GVAR(voiceReady)) exitWith {
    [QEGVAR(sys_io,voiceToken), ["", "the server is not connected to a voice server"], _owner] call CBA_fnc_ownerEvent;
};

TRACE_2("issuing voice token",_uid,_owner);
GVAR(tokenOwners) set [_uid, _owner];
["authority:token", [_uid]] call EFUNC(sys_io,ext);
