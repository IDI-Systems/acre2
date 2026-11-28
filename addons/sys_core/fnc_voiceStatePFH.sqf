#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Keeps the voice extension up to date with what only SQF knows: where our direct speech
 * goes, which radio channels we listen to, Zeus/spectator camera positions, and which player
 * has which voice peer ID. Only sends what changed.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_sys_core_fnc_voiceStatePFH, 0.25] call CBA_fnc_addPerFrameHandler
 *
 * Public: No
 */

if (!EGVAR(sys_io,connected) || {isNull acre_player}) exitWith {};

// Who is who: every player publishes their voice peer ID on their unit.
GVAR(playerList) = (allPlayers apply {[_x getVariable [QGVAR(ts3id), -1], _x]}) select {(_x select 0) != -1};

// Where direct speech goes. Spectators only talk among themselves; during the briefing everyone
// hears everyone.
private _language = [] call FUNC(getSpeakingLanguageId);
private _direct = if (ACRE_IS_SPECTATOR) then {
    [0, ["spectator"], netId acre_player, _language, GVAR(curveScale)]
} else {
    [[] call FUNC(getDirectRange), [], netId acre_player, _language, GVAR(curveScale)]
};
if (GVAR(inBriefing)) then {
    (_direct select 1) pushBack "briefing";
};
if (_direct isNotEqualTo GVAR(lastDirectTx)) then {
    GVAR(lastDirectTx) = _direct;
    ["tx:direct", _direct] call EFUNC(sys_io,ext);
};

// Channels we listen on: god mode (SQF filters by target group), spectator chat, and the
// channel of every radio we can hear.
private _rx = ["god"];
if (ACRE_IS_SPECTATOR) then {
    _rx pushBack "spectator";
};
if (GVAR(inBriefing)) then {
    _rx pushBack "briefing";
};
{
    private _key = [_x, false] call FUNC(getRadioChannelKey);
    if (_key != "") then {
        _rx pushBackUnique _key;
    };
} forEach ([] call FUNC(getHearableRadios));
_rx sort true;
if (_rx isNotEqualTo GVAR(lastRxChannels)) then {
    GVAR(lastRxChannels) = _rx;
    ["rx:channels", [_rx]] call EFUNC(sys_io,ext);
};

// Camera positions: spectators hear from their camera; Zeus hears from the camera, and speaks
// from it while using the Zeus speak key. (The server only accepts these while allowed.)
private _positions = [];
if (ACRE_IS_SPECTATOR) then {
    _positions pushBack [AGLToASL positionCameraToWorld [0, 0, 0], "listener"];
} else {
    if (EGVAR(sys_zeus,zeusCommunicateViaCamera) && {call FUNC(inZeus)}) then {
        private _role = ["listener", "both"] select (player getVariable [QEGVAR(sys_zeus,inZeus), false]);
        _positions pushBack [getPosASL curatorCamera, _role];
    };
};
if (_positions isNotEqualTo GVAR(lastExtraPositions)) then {
    GVAR(lastExtraPositions) = _positions;
    ["self:positions", [_positions]] call EFUNC(sys_io,ext);
};
