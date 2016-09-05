/*
    Copyright � 2010,International Development & Integration Systems, LLC
    All rights reserved.
    http://www.idi-systems.com/

    For personal use only. Military or commercial use is STRICTLY
    prohibited. Redistribution or modification of source code is
    STRICTLY prohibited.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
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
                    private _signalTrace = missionNamespace getVariable [_radioId + "_signal_trace", []];
                    private _signalStartTime = missionNamespace getVariable [_radioId + "_signal_startTime", diag_tickTime];
                    if(_unit != acre_player && ACRE_SIGNAL_DEBUGGING > 0) then {
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
