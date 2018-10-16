#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets up the per frame event handler to mute and unmute clients on TeamSpeak. The muting occurs to optimize TeamSpeak bandwidth as voice data is not sent for muted clients.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_muting
 *
 * Public: No
 */

#define FULL_SEND_INTERVAL 5


GVAR(oldSpectators) = [];
GVAR(lastSpectate) = false;
GVAR(_waitFullSend) = diag_tickTime;
GVAR(_fullListTime) = true;

GVAR(oldPlayerIdList) = [];

DFUNC(mutingPFHLoop) = {
    if (diag_tickTime > GVAR(_waitFullSend)) then {
        GVAR(_fullListTime) = true;
    };
    private _mutingParams = "";
    private _muting = [];
    //private _playerIdList = [];

    // CHANGE: dynamically get muting distanced based on camera *OR* acre_player position
    private _dynamicPos = getPos acre_player;
    if (ACRE_IS_SPECTATOR) then {
        _dynamicPos = positionCameraToWorld[0,0,0];
    };
    {
        _x params ["_remoteTs3Id","_remoteUser"];
        if (_remoteUser != acre_player) then {
            private _muted = 0;
            //private _remoteTs3Id = (_remoteUser getVariable QGVAR(ts3id));
            //if (!(isNil "_remoteTs3Id")) then {
                if (!(_remoteTs3Id in ACRE_SPECTATORS_LIST)) then {
                    private _isRemotePlayerAlive = [_remoteUser] call FUNC(getAlive);
                    if (_isRemotePlayerAlive == 1) then {
                        //_playerIdList pushBack _remoteTs3Id;

                        // private _radioListRemote = [_remoteUser] call EFUNC(sys_data,getRemoteRadioList);
                        // private _radioListLocal = [] call EFUNC(sys_data,getPlayerRadioList);
                        // private _okRadios = [_radioListLocal, _radioListRemote, true] call EFUNC(sys_modes,checkAvailability);
                        if (GVAR(enableDistanceMuting) && {_remoteUser distance _dynamicPos > 300}) then {
                            _muting pushBack _remoteUser;
                            _muted = 1;
                            if (_remoteUser in GVAR(speakers)) then {
                                _muted = 0;
                            };
                        };

                        if (GVAR(_fullListTime)) then {
                            _mutingParams = _mutingParams + format["%1,%2,", _remoteTs3Id, _muted];
                        } else {
                            if ((_muted == 0 && {_remoteUser in GVAR(muting)}) || {(_muted == 1 && {!(_remoteUser in GVAR(muting))})}) then {
                                _mutingParams = _mutingParams + format["%1,%2,", _remoteTs3Id, _muted];
                            };
                        };
                    };
                } else {
                    _muting pushBack _remoteUser;
                };
            //};
        };
    } forEach GVAR(playerList);

    if (!ACRE_IS_SPECTATOR || {GVAR(_fullListTime)}) then {
        private _newSpectators = ACRE_SPECTATORS_LIST - GVAR(oldSpectators);
        if (GVAR(_fullListTime)) then {
            _newSpectators = ACRE_SPECTATORS_LIST;
        };
        if !(_newSpectators isEqualTo []) then {
            {
                if (_x != GVAR(ts3id)) then {
                    _mutingParams = _mutingParams + format["%1,1,", _x];
                };
            } forEach _newSpectators;
            if (!GVAR(_fullListTime)) then {
                GVAR(oldSpectators) = +ACRE_SPECTATORS_LIST;
            };
        };
    } else {
        if ((str ACRE_IS_SPECTATOR) != (str GVAR(lastSpectate))) then {
            if (ACRE_IS_SPECTATOR) then {
                {
                    if (_x != GVAR(ts3id)) then {
                        _mutingParams = _mutingParams + format["%1,0,", _x];
                    };
                } forEach ACRE_SPECTATORS_LIST;
            };
            GVAR(lastSpectate) = ACRE_IS_SPECTATOR;
        };
    };

    if (ACRE_IS_SPECTATOR && {GVAR(_fullListTime)}) then {
        {
            if (_x != GVAR(ts3id)) then {
                _mutingParams = _mutingParams + format["%1,0,", _x];
            };
        } forEach ACRE_SPECTATORS_LIST;
    };

    GVAR(muting) = _muting;
    if (GVAR(_fullListTime)) then {
        GVAR(_waitFullSend) = diag_tickTime + FULL_SEND_INTERVAL;
        GVAR(_fullListTime) = false;
    };
    if (_mutingParams != "") then {
        CALL_RPC("setMuted",_mutingParams);
    };
    true
};

// Wait until time > 0, to save check in PFH
[{time > 0},{
    ADDPFH(FUNC(mutingPFHLoop), 0.25, []);
},[]] call CBA_fnc_waitUntilAndExecute;
