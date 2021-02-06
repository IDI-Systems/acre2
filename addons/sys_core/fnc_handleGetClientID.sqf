#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles receipt of Mumble/TS client ID alongside its objects network ID.
 *
 * Arguments:
 * 0: Mumble/TS client ID <STRING>
 * 1: Net ID of object for Mumble/TS client ID <STRING>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * ["2","2:3"] call acre_sys_core_fnc_handleGetClientID
 *
 * Public: No
 */

params ["_newVoipId", "_netId"];

_newVoipId = parseNumber _newVoipId;

private _playerObject = objectFromNetId _netId;
TRACE_1("got client ID", _this);
if (_playerObject == acre_player) then {
    private _resendSpectator = false;
    if (_newVoipId != GVAR(voipId)) then {
        if (ACRE_IS_SPECTATOR) then {
            [] call FUNC(spectatorOff);
            _resendSpectator = true;
        };
    };
    GVAR(voipId) = _newVoipId;
    if (_resendSpectator) then {
        [] call FUNC(spectatorOn)
    };
    TRACE_1("SETTING VOIPID",GVAR(voipId));
} else {
    _playerObject setVariable [QGVAR(voipId), _newVoipId, false];
};

// Ensure the incoming Mumble/TS ID is pointing to the correct unit.
private _found = false;
{
    _x params ["_remoteVoipId", "_remoteUser"];
    if (_remoteVoipId == _newVoipId) exitWith {
        _found = true;
        if (_playerObject != _remoteUser) then {
            GVAR(playerList) set [_forEachIndex, [_newVoipId, _playerObject]];
            //If changed remove.
            REM(GVAR(speakers),_remoteUser);
            REM(GVAR(spectatorSpeakers),_remoteVoipId);
            REM(GVAR(godSpeakers),_remoteVoipId);
            REM(GVAR(keyedMicRadios),_remoteUser);
        };
        // Case where objects dont match but we found our Mumble/TS ID.
    };
} forEach (GVAR(playerList));
if (!_found) then {
    GVAR(playerList) pushBack [_newVoipId,_playerObject];
};

true
