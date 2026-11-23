#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Connects the server to the voice server as its authority, using the voice extension's config
 * file (acre2_voice.toml in the server folder, or ACRE2_VOICE_CONFIG). Retries until it
 * succeeds, and starts feeding player positions.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_server_fnc_startAuthority
 *
 * Public: No
 */

if (!isMultiplayer) exitWith {};

if (!EGVAR(sys_io,initialized)) then {
    EGVAR(sys_io,initialized) = (["init"] call EFUNC(sys_io,ext)) != "";
};
if (!EGVAR(sys_io,initialized)) exitWith {
    ERROR("The voice extension (acre_voice_x64) could not be loaded on the server.");
};

if (isNil QGVAR(voiceStatePFH)) then {
    GVAR(voiceStatePFH) = [FUNC(voiceStatePFH), VOICE_WORLD_INTERVAL, []] call CBA_fnc_addPerFrameHandler;
};

if ((["authority:start", []] call EFUNC(sys_io,ext)) != "ok") then {
    ERROR("Could not start the voice server connection: check acre2_voice.toml in the server folder. Retrying.");
    [FUNC(startAuthority), [], VOICE_RETRY_INTERVAL] call CBA_fnc_waitAndExecute;
};
