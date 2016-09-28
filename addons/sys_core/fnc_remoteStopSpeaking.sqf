/*
 * Author: ACRE2Team
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

params["_speakingId","_netId"];
_speakingId = parseNumber _speakingId;
// if(_speakingId != GVAR(ts3id)) then {
    private _found = false;
    private _unit = objectFromNetId _netId;
    if(!isNil "_unit") then {

        _found = true;
        #ifdef PLATFORM_A3
        _unit setRandomLip false;
        #endif
        REM(GVAR(speakers),_unit);
        private _radioId = _unit getVariable[QUOTE(GVAR(currentSpeakingRadio)), ""];
        //if(ACRE_BROADCASTING_RADIOID != _radioId) then {
            if(_radioId != "") then {
                if(_unit in GVAR(keyedMicRadios)) then {
                    GVAR(speaking_cache_valid) = false;
                    // clear out their signal caches from sys_signal call backs.
                    missionNamespace setVariable [_radioId + "_best_signal", -992];
                    missionNamespace setVariable [_radioId + "_best_px", 0];
                    missionNamespace setVariable [_radioId + "_best_ant", ""];

                    if(_unit != acre_player && ACRE_SIGNAL_DEBUGGING > 0) then {
                        private _signalTrace = missionNamespace getVariable [_radioId + "_signal_trace", []];
                        private _signalStartTime = missionNamespace getVariable [_radioId + "_signal_startTime", diag_tickTime];
                        diag_log text format["ACRE TX from %1 (on radio %2, distance at end: %3 m), duration %4s: %5", name _unit, _radioId, (_unit distance acre_player), diag_tickTime-_signalStartTime, _signalTrace];
                    };
                    missionNamespace setVariable [_radioId + "_signal_trace", []];
                    private _okRadios = [[_radioId], ([] call EFUNC(sys_data,getPlayerRadioList)) + GVAR(nearRadios), false] call EFUNC(sys_modes,checkAvailability);
                    _okRadios = (_okRadios select 0) select 1;
                    //_okRadios = _okRadios - [ACRE_BROADCASTING_RADIOID];
                    if((count _okRadios) > 0) then {
                        {
                            [_x, "handleEndTransmission", [_radioId]] call EFUNC(sys_data,transEvent);
                        } forEach _okRadios;
                    };
                };
                if(HASH_HASKEY(GVAR(keyedRadioIds), _radioId)) then {
                    HASH_REM(GVAR(keyedRadioIds), _radioId);
                };
            };
        // } else {
            // ACRE_BROADCASTING_RADIOID = "";
        // };
        REM(GVAR(keyedMicRadios),_unit);

        _unit setVariable[QUOTE(GVAR(currentSpeakingRadio)), ""];
        _unit setVariable[QUOTE(currentListeningRadio), ""];
        TRACE_2("speakers",GVAR(speakers),GVAR(keyedMicRadios));
        if(_unit == acre_player) then {
            ACRE_BROADCASTING_RADIOID = "";
        };
    };
    if(_speakingId in ACRE_SPECTATORS_LIST) then {
        _found = true;
        REM(GVAR(spectatorSpeakers), _speakingId);
    };
    if(!_found) then {
        private _msg = format["STOP SPEAKING: Player [%1] could not find a player with ID: %2 %3", acre_player, _speakingId, _netId];
        // REMOTEDEBUGMSG(_msg);
        diag_log text format["%1 ACRE: %2", diag_tickTime, _msg];
    };
    TRACE_1("REMOTE STOPPED SPEAKING",_speakingId);

    GVAR(speakers) = GVAR(speakers) - [objNull];
    GVAR(keyedMicRadios) = GVAR(keyedMicRadios) - [objNull];

// };
DUMP_COUNTERS;
true
