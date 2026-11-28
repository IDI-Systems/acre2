#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the server's answer to a token request: connects to the voice server.
 *
 * Arguments:
 * 0: Token (hex), or "" on failure <STRING>
 * 1: Voice server address, or the failure reason <STRING>
 * 2: Voice server certificate fingerprint (hex) <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ab12…", "voice.example.com:9987", "cd34…"] call acre_sys_io_fnc_handleToken
 *
 * Public: No
 */

params ["_token", "_address", ["_fingerprint", ""]];

if (_token == "") exitWith {
    WARNING_1("Server could not provide a voice token: %1",_address);
};

if (GVAR(connected) || {GVAR(connecting)}) exitWith {};

TRACE_1("connecting to voice server",_address);
GVAR(connecting) = true;
if (["voice:connect", [_address, _token, _fingerprint]] call FUNC(ext) != "ok") then {
    GVAR(connecting) = false;
};
