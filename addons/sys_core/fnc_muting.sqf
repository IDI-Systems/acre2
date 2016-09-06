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

#define FULL_SEND_INTERVAL 5


GVAR(oldSpectators) = [];
GVAR(lastSpectate) = false;
GVAR(_waitFullSend) = COMPAT_diag_tickTime;
GVAR(_fullListTime) = true;

GVAR(oldPlayerIdList) = [];

DFUNC(mutingPFHLoop) = {

    if(time == 0) exitWith {
        true;
    };
    if(COMPAT_diag_tickTime > GVAR(_waitFullSend)) then {
        GVAR(_fullListTime) = true;
    };
    private _mutingParams = "";
    private _muting = [];
    //private _playerIdList = [];

    // CHANGE: dynamically get muting distanced based on camera *OR* acre_player position
    private _dynamicPos = getPos acre_player;
    if(ACRE_IS_SPECTATOR) then {
        _dynamicPos = positionCameraToWorld[0,0,0];
    };
    {
        _x params ["_remoteTs3Id","_remoteUser"];
        if(_remoteUser != acre_player) then {
            private _muted = 0;
            //private _remoteTs3Id = (_remoteUser getVariable QUOTE(GVAR(ts3id)));
            //if(!(isNil "_remoteTs3Id")) then {
                if(!(_remoteTs3Id in ACRE_SPECTATORS_LIST)) then {
                    private _isRemotePlayerAlive = [_remoteUser] call FUNC(getAlive);
                    if(_isRemotePlayerAlive == 1) then {
                        //PUSH(_playerIdList, _remoteTs3Id);

                        // private _radioListRemote = [_remoteUser] call EFUNC(sys_data,getRemoteRadioList);
                        // private _radioListLocal = [] call EFUNC(sys_data,getPlayerRadioList);
                        // private _okRadios = [_radioListLocal, _radioListRemote, true] call EFUNC(sys_modes,checkAvailability);
                        if(_remoteUser distance _dynamicPos > 300) then {
                            PUSH(_muting,_remoteUser);
                            _muted = 1;
                        };
                        if(_remoteUser in GVAR(speakers)) then {
                            _muted = 0;
                        };
                        if(GVAR(_fullListTime)) then {
                            _mutingParams = _mutingParams + format["%1,%2,", _remoteTs3Id, _muted];
                            _remoteUser setVariable[QUOTE(GVAR(muted)), _muted, false];
                        } else {
                            if(((_remoteUser in GVAR(muting)) && _muted == 0) || (!(_remoteUser in GVAR(muting)) && _muted == 1)) then {
                                _mutingParams = _mutingParams + format["%1,%2,", _remoteTs3Id, _muted];
                                _remoteUser setVariable[QUOTE(GVAR(muted)), _muted, false];
                            };
                        };
                    };
                } else {
                    PUSH(_muting,_remoteUser);
                    _remoteUser setVariable[QUOTE(GVAR(muted)), 1, false];
                };
            //};
        };
    } forEach GVAR(playerList);

    if(!ACRE_IS_SPECTATOR || GVAR(_fullListTime)) then {
        private _newSpectators = ACRE_SPECTATORS_LIST - GVAR(oldSpectators);
        if(GVAR(_fullListTime)) then {
            _newSpectators = ACRE_SPECTATORS_LIST;
        };
        if((count _newSpectators) > 0) then {
            {
                if(_x != GVAR(ts3id)) then {
                    _mutingParams = _mutingParams + format["%1,%2,", _x, 1];
                };
            } forEach _newSpectators;
            if(!GVAR(_fullListTime)) then {
                GVAR(oldSpectators) = +ACRE_SPECTATORS_LIST;
            };
        };
    } else {
        if((str ACRE_IS_SPECTATOR) != (str GVAR(lastSpectate))) then {
            if(ACRE_IS_SPECTATOR) then {
                {
                    if(_x != GVAR(ts3id)) then {
                        _mutingParams = _mutingParams + format["%1,%2,", _x, 0];
                    };
                } forEach ACRE_SPECTATORS_LIST;
            };
            GVAR(lastSpectate) = ACRE_IS_SPECTATOR;
        };
    };

    if(ACRE_IS_SPECTATOR && GVAR(_fullListTime)) then {
        {
            if(_x != GVAR(ts3id)) then {
                _mutingParams = _mutingParams + format["%1,%2,", _x, 0];
            };
        } forEach ACRE_SPECTATORS_LIST;
    };

    GVAR(muting) = _muting;
    if(GVAR(_fullListTime)) then {
        GVAR(_waitFullSend) = COMPAT_diag_tickTime + FULL_SEND_INTERVAL;
        GVAR(_fullListTime) = false;
    };
    if(_mutingParams != "") then {
        CALL_RPC("setMuted",_mutingParams);
    };
    true
};
ADDPFH(DFUNC(mutingPFHLoop), 0.25, []);
