/*
 * Author: AUTHOR
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

#include "script_component.hpp"

params ["_newTs3Id","_netId"];

_newTs3Id = parseNumber _newTs3Id;

_playerObject = objectFromNetId _netId;
TRACE_1("got client ID", _this);
if(_playerObject == acre_player) then {
    _resendSpectator = false;
    if(_newTs3Id != GVAR(ts3id)) then {
        if(ACRE_IS_SPECTATOR) then {
            [] call FUNC(spectatorOff);
            _resendSpectator = true;
        };
    };
    GVAR(ts3id) = _newTs3Id;
    if(_resendSpectator) then {
        [] call FUNC(spectatorOn)
    };
    TRACE_1("SETTING TS3ID",GVAR(ts3id));
} else {
    _playerObject setVariable [QUOTE(GVAR(ts3id)), _newTs3Id, false];
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
