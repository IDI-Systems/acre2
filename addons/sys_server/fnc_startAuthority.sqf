#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Hosts the voice server inside the voice extension, on the port and public address from the
 * CBA server settings (or ACRE2_VOICE_PORT / ACRE2_VOICE_ADDRESS), and starts feeding it player
 * positions.
 *
 * Arguments:
 * 0: Restart (the voice server was lost); otherwise only the first call starts it <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_server_fnc_startAuthority
 *
 * Public: No
 */

params [["_restart", false]];

if (!isMultiplayer) exitWith {};
if (!_restart && {!isNil QGVAR(voiceHostStarted)}) exitWith {};
GVAR(voiceHostStarted) = true;

if (!EGVAR(sys_io,initialized)) then {
    EGVAR(sys_io,initialized) = (["init"] call EFUNC(sys_io,ext)) != "";
};
if (!EGVAR(sys_io,initialized)) exitWith {
    ERROR("The voice extension (acre_voice_x64) could not be loaded on the server.");
};

if (isNil QGVAR(voiceStatePFH)) then {
    GVAR(voiceStatePFH) = [FUNC(voiceStatePFH), VOICE_WORLD_INTERVAL, []] call CBA_fnc_addPerFrameHandler;
};

private _port = parseNumber (missionNamespace getVariable [QGVAR(voicePort), "9987"]);
if (_port < 0 || {_port > 65535}) exitWith {
    ERROR_1("Voice port %1 is not a valid UDP port. Set it in the ACRE2 Voice Server settings.",_port);
};
private _address = missionNamespace getVariable [QGVAR(voiceAddress), ""];

if ((["server:start", [_port, _address]] call EFUNC(sys_io,ext)) != "ok") then {
    ERROR("Could not start the voice server. Check the ACRE2 Voice Server settings (port, public address) and the RPT warning above.");
};
