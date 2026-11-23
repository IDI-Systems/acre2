#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Feeds the voice server where players are (for direct speech), and lets curators and
 * spectators report their camera positions.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_sys_server_fnc_voiceStatePFH, 0.1] call CBA_fnc_addPerFrameHandler
 *
 * Public: No
 */

if (!GVAR(voiceReady)) exitWith {};

private _players = allPlayers - entities "HeadlessClient_F";
private _updates = [];
private _cameraUsers = [];
{
    private _uid = getPlayerUID _x;
    if (_uid != "") then {
        private _isSpectator = (_x getVariable [QEGVAR(sys_core,ts3id), -1]) in ACRE_SPECTATORS_LIST;
        _updates pushBack [_uid, eyePos _x, alive _x && {!_isSpectator}];
        if (_isSpectator || {!isNull getAssignedCuratorLogic _x}) then {
            _cameraUsers pushBack _uid;
        };
    };
} forEach _players;

["authority:world", [_updates]] call EFUNC(sys_io,ext);

if (_cameraUsers isNotEqualTo GVAR(reportPositionAllowed)) then {
    {
        ["authority:report_position", [_x, true]] call EFUNC(sys_io,ext);
    } forEach (_cameraUsers - GVAR(reportPositionAllowed));
    {
        ["authority:report_position", [_x, false]] call EFUNC(sys_io,ext);
    } forEach (GVAR(reportPositionAllowed) - _cameraUsers);
    GVAR(reportPositionAllowed) = _cameraUsers;
};
