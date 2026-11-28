#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Starts the voice client: initialises the voice extension and keeps asking the server for a
 * join token until connected (again after disconnects).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_io_fnc_startClient
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

private _version = ["init"] call FUNC(ext);
if (_version == "") exitWith {
    ERROR_WITH_TITLE("ACRE","The voice extension (acre_voice_x64) could not be loaded.");
};
GVAR(initialized) = true;
INFO_1("Voice extension %1 loaded.",_version);

#ifndef DEBUG_MODE_FULL
if (!isMultiplayer) exitWith {};
#endif

// The server stops its voice server when the mission ends: leave quietly instead of retrying.
addMissionEventHandler ["MPEnded", {
    GVAR(missionEnded) = true;
    ["voice:disconnect"] call FUNC(ext);
    if (GVAR(connected)) then {
        GVAR(connected) = false;
        GVAR(peerId) = -1;
        [] call EFUNC(sys_core,handleVoiceDisconnected);
    };
}];

[{
    if (GVAR(missionEnded) || {GVAR(connected)} || {GVAR(connecting)}) exitWith {};
    if (diag_tickTime - GVAR(lastTokenRequest) < TOKEN_RETRY_INTERVAL) exitWith {};
    [] call FUNC(requestToken);
}, 1, []] call CBA_fnc_addPerFrameHandler;
