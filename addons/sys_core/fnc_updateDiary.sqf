#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Keeps the "ACRE Voice" map diary page up to date: connection, latency, packet loss,
 * bandwidth and microphone settings.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [acre_sys_core_fnc_updateDiary, 2] call CBA_fnc_addPerFrameHandler
 *
 * Public: No
 */

if (isNull player) exitWith {};

// Diary pages belong to the unit: recreate after respawn or switching units.
if (GVAR(diaryUnit) isNotEqualTo player) then {
    if !(player diarySubjectExists QGVAR(voice)) then {
        player createDiarySubject [QGVAR(voice), localize LSTRING(diary_subject)];
    };
    GVAR(diaryRecord) = player createDiaryRecord [QGVAR(voice), [localize LSTRING(diary_title), ""]];
    GVAR(diaryUnit) = player;
};

private _stats = ["voice:stats", []] call EFUNC(sys_io,ext);
if (_stats == "") exitWith {};
(parseSimpleArray _stats) params [
    "_state", "_peer", "_address", "_rtt", "_sentLoss", "_receivedLoss", "_kbitIn", "_kbitOut", "_speaking", "_lastError"
];

private _lines = [];
switch (_state) do {
    case "connected": {
        _lines pushBack format [localize LSTRING(diary_connected), _address, _peer];
        _lines pushBack format [localize LSTRING(diary_latency), round _rtt];
        _lines pushBack format [localize LSTRING(diary_loss), _sentLoss toFixed 1, _receivedLoss toFixed 1];
        _lines pushBack format [localize LSTRING(diary_bandwidth), _kbitIn toFixed 1, _kbitOut toFixed 1];
        _lines pushBack format [localize LSTRING(diary_speaking), _speaking];
    };
    case "connecting": {
        _lines pushBack format [localize LSTRING(diary_connecting), _address];
    };
    default {
        _lines pushBack localize LSTRING(diary_disconnected);
        if (_lastError != "") then {
            _lines pushBack format [localize LSTRING(diary_lastError), _lastError];
        };
    };
};

_lines pushBack "";
private _ptt = (missionNamespace getVariable [QGVAR(voiceActivation), 0]) == 1;
_lines pushBack format [
    localize LSTRING(diary_activation),
    localize ([LSTRING(voiceActivation_vad), LSTRING(voiceActivation_ptt)] select _ptt),
    round (missionNamespace getVariable [QGVAR(voiceThreshold), -45]),
    round (missionNamespace getVariable [QGVAR(voiceThresholdClose), -50])
];
_lines pushBack format [localize LSTRING(diary_micLevel), round (parseNumber (["audio:level", []] call EFUNC(sys_io,ext)))];
_lines pushBack "";
_lines pushBack format ["<execute expression='[] call %1'>%2</execute>", QFUNC(micTestOpen), localize LSTRING(micTest_title)];

player setDiaryRecordText [[QGVAR(voice), GVAR(diaryRecord)], [localize LSTRING(diary_title), _lines joinString "<br/>"]];
