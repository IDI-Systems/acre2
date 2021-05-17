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
GVAR(waitFullSend) = diag_tickTime;
GVAR(fullListTime) = true;

GVAR(oldPlayerIdList) = [];

DFUNC(mutingPFHLoop) = {
    if (diag_tickTime > GVAR(waitFullSend)) then {
        GVAR(fullListTime) = true;
    };
    private _mutingParams = "";

    // CHANGE: dynamically get muting distanced based on camera *OR* acre_player position
    private _dynamicPos = getPos acre_player;
    if (ACRE_IS_SPECTATOR) then {
        _dynamicPos = positionCameraToWorld [0, 0, 0];
    };
    private _mutedClients = [];

    {
        _x params ["_remoteTs3Id","_remoteUser"];
        if (_remoteUser != acre_player) then {
            private _muted = [_remoteUser, _remoteTs3Id, _dynamicPos] call FUNC(shouldBeMuted);

            if (GVAR(fullListTime)) then {
                _mutingParams = _mutingParams + format ["%1,%2,", _remoteTs3Id, parseNumber _muted];
                if (_muted) then {
                    _mutedClients pushBack _remoteUser;
                };
                continue;
            };
            private _isCurrentlyMuted = _remoteUser in GVAR(muting);
            if (_isCurrentlyMuted && !_muted) then {
                _mutingParams = _mutingParams + format ["%1,0,", _remoteTs3Id];
                GVAR(muting) deleteAt (GVAR(muting) find _remoteUser);
            } else {
                if (!_isCurrentlyMuted && _muted) then {
                    _mutingParams = _mutingParams + format ["%1,1,", _remoteTs3Id];
                    GVAR(muting) pushBackUnique _remoteUser;
                };
            };
        };
    } forEach GVAR(playerList);
    if (GVAR(fullListTime)) then {
        GVAR(muting) = _mutedClients;
    };

    if (GVAR(fullListTime)) then {
        GVAR(waitFullSend) = diag_tickTime + FULL_SEND_INTERVAL;
        GVAR(fullListTime) = false;
    };
    if (_mutingParams != "") then {
        CALL_RPC("setMuted",_mutingParams);
    };
    true
};

// Wait until time > 0, to save check in PFH
[{time > 0}, {
    [FUNC(mutingPFHLoop), 0.25, []] call CBA_fnc_addPerFrameHandler;
}, []] call CBA_fnc_waitUntilAndExecute;
