#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles receipt of TS client ID alongside its objects network ID.
 *
 * Arguments:
 * 0: TS client ID <STRING>
 * 1: Net ID of object for TS client ID <STRING>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * ["2","2:3"] call acre_sys_core_fnc_handleGetClientID
 *
 * Public: No
 */

params ["_newTs3Id","_netId"];

_newTs3Id = parseNumber _newTs3Id;

private _playerObject = objectFromNetId _netId;
TRACE_1("got client ID", _this);
if (_playerObject == acre_player) then {
    private _resendSpectator = false;
    if (_newTs3Id != GVAR(ts3id)) then {
        if (ACRE_IS_SPECTATOR) then {
            [] call FUNC(spectatorOff);
            _resendSpectator = true;
        };
    };
    GVAR(ts3id) = _newTs3Id;
    if (_resendSpectator) then {
        [] call FUNC(spectatorOn)
    };
    TRACE_1("SETTING TS3ID",GVAR(ts3id));
} else {
    _playerObject setVariable [QGVAR(ts3id), _newTs3Id, false];
};

//Ensure the incoming TS ID is pointing to the correct unit.
private _found = false;
{
    _x params ["_remoteTs3Id","_remoteUser"];
    if (_remoteTs3Id == _newTs3Id) exitWith {
        _found = true;
        if (_playerObject != _remoteUser) then {
            GVAR(playerList) set [_forEachIndex, [_newTs3Id, _playerObject]];
            //If changed remove.
            REM(GVAR(speakers),_remoteUser);
            REM(GVAR(spectatorSpeakers),_remoteTs3Id);
            REM(GVAR(keyedMicRadios),_remoteUser);
        };
        // Case where objects dont match but we found our TS ID.
    };
} forEach (GVAR(playerList));
if (!_found) then {
    GVAR(playerList) pushBack [_newTs3Id,_playerObject];
};

true
