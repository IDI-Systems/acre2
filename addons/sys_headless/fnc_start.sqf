#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Starts a unit speaking from a headless TS client
 * Must be called on all clients
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: TS Display Name (name of a TS source inside the ACRE channel) <STRING>
 * 2: Language Index <NUMBER>
 * 3: Speaking Type (0 direct, 1 radio,...) <NUMBER>
 * 4: Radio ID <STRING>
 *
 * Return Value:
 * Started <BOOL>
 *
 * Example:
 * [q2, "Botty", 0, 0, ""] call acre_sys_headless_fnc_start
 * [q2, "Botty", 0, 1, "ACRE_PRC343_ID_2"] call acre_sys_headless_fnc_start
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params ["_unit", "_tsDisplayName", "_languageId", "_speakingType", "_radioId"];
TRACE_4("start",_unit,_tsName,_languageId,_speakingType,_radioId);

if (!alive _unit) exitWith { ERROR_1("bad unit",_this);  false };
if (!isNil {_unit getVariable [QGVAR(keepRunning), nil]}) exitWith {  ERROR_1("unit is already active",_this); false };

if (isNil QGVAR(idsToCleanup)) then { GVAR(idsToCleanup) = []; };

private _netId = netId _unit;

// start getting tsId, won't have result until next frame+
private _lastKnownId = 0; 
_unit setVariable [QGVAR(virtualID), _lastKnownId];
["getHeadlessID", [_netId, _tsDisplayName]] call EFUNC(sys_rpc,callRemoteProcedure);

_unit setVariable [QGVAR(keepRunning), true];

[{
    params ["_args", "_pfid"];
    _args params ["_unit", "_tsDisplayName", "_lastKnownId", "_languageId", "_netId", "_speakingType", "_radioID"];
    private _currentId = _unit getVariable [QGVAR(virtualID), 0];
    private _isSpeaking = [_unit] call EFUNC(api,isSpeaking);
    private _keepRunning = (_unit getVariable [QGVAR(keepRunning), false]) && {alive _unit};
    TRACE_5("tick",_unit,_lastKnownId,_currentId,_isSpeaking,_keepRunning);

    if ((_lastKnownId == 0) && {_currentId != 0}) then {
        // When we first get a new valid ID, Ensure bot is not currently in plugin's speakingList (just in case it was never cleared)
        TRACE_1("RPC STOP: reset on new ID",_currentId);
        [
            "ext_remoteStopSpeaking", 
            format ["%1,", _currentId]
        ] call EFUNC(sys_rpc,callRemoteProcedure);
    };
    if (_isSpeaking) then {
        // Handle client TS closed / pipe error - Need to manually do sqf-stopspeaking to remove from speakers list
        if (!EGVAR(sys_io,serverStarted)) then {
            TRACE_2("manual sqf stopspeaking: plugin problems",_currentId,_keepRunning);
            _currentId = 0;
            [str _lastKnownId, _netId] call EFUNC(sys_core,remoteStopSpeaking);
        };
        // Normal shutdown or we lost tsID (bot disconnect)
        if ((!_keepRunning) || {_currentId == 0}) then {
            TRACE_2("RPC STOP: shutdown or bad ID",_keepRunning,_currentId);
            [
                "ext_remoteStopSpeaking", 
                format ["%1,", _lastKnownId]
            ] call EFUNC(sys_rpc,callRemoteProcedure);
        };
    } else {
        if (_keepRunning && {_currentId != 0}) then {
            TRACE_1("RPC START: normal",_currentId);
            [
                "ext_remoteStartSpeaking", 
                format ["%1,%2,%3,%4,%5,%6,", _currentId, _languageId, _netId, _speakingType, _radioId, 1]
            ] call EFUNC(sys_rpc,callRemoteProcedure);
        }; 
    };
    _args set [2, _currentId];
    if (_currentId !=0) then { GVAR(idsToCleanup) pushBackUnique _currentId; };

    if (_keepRunning) then {
        // Keep checking ID, this handles a bot disconnecting and reconnecting under a different ID
        ["getHeadlessID", [_netId, _tsDisplayName]] call EFUNC(sys_rpc,callRemoteProcedure);
    } else {
        TRACE_1("pfeh stop",_this);
        [_pfid] call CBA_fnc_removePerFrameHandler;
        _unit setVariable [QGVAR(keepRunning), nil];
    };
}, 0.5, [_unit, _tsDisplayName, _lastKnownId, _languageId, _netID, _speakingType, _radioId]] call CBA_fnc_addPerFrameHandler;

true
