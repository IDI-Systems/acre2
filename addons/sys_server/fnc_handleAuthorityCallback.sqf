#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the voice extension's authority callbacks on the server.
 *
 * Arguments:
 * 0: Function <STRING>
 * 1: Arguments <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["token", ["7656…", "ab12…", "voice.example.com:9987", "cd34…"]] call acre_sys_server_fnc_handleAuthorityCallback
 *
 * Public: No
 */

params ["_function", "_args"];

switch (_function) do {
    case "authority_connected": {
        _args params ["_fingerprint", "_address"];
        INFO_2("Connected to the voice server. Players will connect to %1 (certificate %2).",_address,_fingerprint);
        GVAR(voiceReady) = true;
        // The voice server may have restarted: grant permissions afresh.
        GVAR(reportPositionAllowed) = [];
    };
    case "authority_failed";
    case "authority_disconnected": {
        _args params ["_reason"];
        GVAR(voiceReady) = false;
        WARNING_1("Voice server connection lost or refused: %1. Restarting it.",_reason);
        [FUNC(startAuthority), [true], VOICE_RETRY_INTERVAL] call CBA_fnc_waitAndExecute;
    };
    case "token": {
        _args params ["_uid", "_token", "_address", "_fingerprint"];
        private _owner = GVAR(tokenOwners) getOrDefault [_uid, -1];
        GVAR(tokenOwners) deleteAt _uid;
        if (_owner != -1) then {
            [QEGVAR(sys_io,voiceToken), [_token, _address, _fingerprint], _owner] call CBA_fnc_ownerEvent;
        };
    };
    case "token_failed": {
        _args params ["_uid", "_reason"];
        private _owner = GVAR(tokenOwners) getOrDefault [_uid, -1];
        GVAR(tokenOwners) deleteAt _uid;
        if (_owner != -1) then {
            [QEGVAR(sys_io,voiceToken), ["", _reason], _owner] call CBA_fnc_ownerEvent;
        };
    };
    case "peer_connected": {
        TRACE_1("voice peer connected",_args);
    };
    case "peer_disconnected": {
        TRACE_1("voice peer disconnected",_args);
    };
    case "authority_error": {
        WARNING_1("Voice server: %1",_args select 0);
    };
    default {
        WARNING_2("Unknown voice callback %1: %2",_function,_args);
    };
};
