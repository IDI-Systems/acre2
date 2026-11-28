#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Dispatches an ExtensionCallback from the voice extension.
 *
 * Arguments:
 * 0: Function <STRING>
 * 1: Data, an SQF array <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["connected", "[3]"] call acre_sys_io_fnc_handleCallback
 *
 * Public: No
 */

params ["_function", "_data"];

private _args = parseSimpleArray _data;
TRACE_2("voice callback",_function,_args);

switch (_function) do {
    // ---- player ----
    case "connected": {
        _args params ["_peerId"];
        GVAR(connecting) = false;
        GVAR(connected) = true;
        GVAR(peerId) = _peerId;
        GVAR(lastConnectError) = "";
        INFO_1("Connected to the voice server as peer %1.",_peerId);
        [_peerId] call EFUNC(sys_core,handleVoiceConnected);
        if (GVAR(hasConnectedBefore)) then {
            [[format ["<t color='#2B7319'>%1</t>", localize LSTRING(recoveredConnection)], 1.5]] call CBA_fnc_notify;
        } else {
            [format ["<t color='#2B7319'>%1</t>", localize LSTRING(acreConnected)]] call CBA_fnc_notify;
        };
        GVAR(hasConnectedBefore) = true;
    };
    case "connect_failed": {
        _args params ["_reason"];
        GVAR(connecting) = false;
        // Retries happen every few seconds: only log when the reason changes.
        if (_reason isEqualTo GVAR(lastConnectError)) exitWith {};
        GVAR(lastConnectError) = _reason;
        WARNING_1("Could not connect to the voice server: %1",_reason);
        if (time > 15) then {
            [[format ["<t color='#FF8021'>%1</t><br/>%2", localize LSTRING(acreNotConnected), _reason], 1.5]] call CBA_fnc_notify;
        };
    };
    case "disconnected": {
        _args params ["_reason"];
        GVAR(connecting) = false;
        GVAR(connected) = false;
        GVAR(peerId) = -1;
        [] call EFUNC(sys_core,handleVoiceDisconnected);
        // The server stops its voice server at mission end (possibly just before our own
        // mission end event): expected, so no warning.
        if (GVAR(missionEnded) || {_reason == "server shutting down"}) exitWith {
            INFO_1("Disconnected from the voice server: %1",_reason);
        };
        WARNING_1("Disconnected from the voice server: %1",_reason);
        [[format ["<t color='#FF8021'>%1</t><br/>%2", localize LSTRING(acreNotConnected), _reason], 1.5]] call CBA_fnc_notify;
    };
    case "remote_start": {
        // [peerId, languageId, netId, speakingType, radioId]
        _args call EFUNC(sys_core,remoteStartSpeaking);
    };
    case "remote_stop": {
        // [peerId, netId]
        _args call EFUNC(sys_core,remoteStopSpeaking);
    };
    case "local_start": {
        // [peerId, languageId, speakingType, radioId]
        _args call EFUNC(sys_core,localStartSpeaking);
    };
    case "local_stop": {
        _args call EFUNC(sys_core,localStopSpeaking);
    };
    case "server_error": {
        WARNING_1("Voice server refused a request: %1",_args select 0);
    };
    case "device": {
        INFO_1("Audio device: %1",_args select 0);
    };
    // ---- server (authority) ----
    default {
        if (isServer) then {
            [_function, _args] call EFUNC(sys_server,handleAuthorityCallback);
        } else {
            WARNING_2("Unknown voice callback %1: %2",_function,_data);
        };
    };
};
