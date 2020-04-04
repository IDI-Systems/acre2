#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the event of other (remote) players starting to speaking.
 *
 * Arguments:
 * 0: TeamSpeak ID of talking player <STRING>
 * 1: Language ID <STRING>
 * 2: Net ID of player object <STRING>
 * 3: On radio <STRING>
 * 4: Radio ID (default: ',') <STRING>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_core_fnc_remoteStartSpeaking
 *
 * Public: No
 */

ACRE_COUNTERS = [];
CREATE_COUNTER(speaking_loop);
CREATE_COUNTER(speaking_loop_with_transmissions);
CREATE_COUNTER(signal_code);
CREATE_COUNTER(radio_loop);
CREATE_COUNTER(muting);
CREATE_COUNTER(updateSpeakingData_loop);
CREATE_COUNTER(handleMultipleTransmissions);
CREATE_COUNTER(data_events);
CREATE_COUNTER(radio_loop_single_radio);
CREATE_COUNTER(hearableRadios);
// PREP(processRadioSpeaker);

TRACE_1("START SPEAKING ENTER", _this);
params ["_speakingId","_languageId","_netId","_onRadio",["_radioId",","]];

if (!(_speakingId isEqualType 0)) then { _speakingId = parseNumber _speakingId; };
if (!(_languageId isEqualType 0)) then { _languageId = parseNumber _languageId; };
if (!(_onRadio isEqualType 0)) then { _onRadio = parseNumber _onRadio; };


private _result = false;
//if (_onRadio != 1 || {_radioId != ACRE_BROADCASTING_RADIOID}) then {
    private _unit = objectFromNetId _netId; // will be objNull if not found.

    //Ensure unit wasn't previously speaking
    REM(GVAR(speakers),_unit);
    REM(GVAR(spectatorSpeakers),_speakingId);
    REM(GVAR(keyedMicRadios),_unit);

    //Ensure the incoming ID is solid.
    private _found = false;
    {
        _x params ["_remoteTs3Id","_remoteUser"];
        if (_remoteTs3Id == _speakingId) exitWith {
            _found = true;
            if (_unit != _remoteUser) then {
                GVAR(playerList) set [_forEachIndex, [_speakingId, _unit]];
                REM(GVAR(speakers),_remoteUser);
                REM(GVAR(spectatorSpeakers),_remoteTs3Id);
                REM(GVAR(keyedMicRadios),_remoteUser);
                /*if (_remoteTs3Id in ACRE_SPECTATORS_LIST) then {
                    GVAR(spectatorSpeakers) pushBackUnique _remoteTs3Id;
                };*/
            };
            // Case where objects dont match but we found our TS ID.
        };
    } forEach (GVAR(playerList));
    if (!_found) then {
        GVAR(playerList) pushBack [_speakingId,_unit];
    };

    if (_speakingId in ACRE_SPECTATORS_LIST) exitWith {
        GVAR(spectatorSpeakers) pushBack _speakingId;
        false;
    };

    if (isNull _unit) exitWith {
        WARNING_4("START SPEAKING: acre_player [%1] could not find a player with ID: %2 %3, On Radio: %4",acre_player,_speakingId,_netId,_onRadio);
        false
    };

    _unit setVariable [QGVAR(ts3id), _speakingId];
    _unit setVariable [QGVAR(languageId), _languageId];
    TRACE_1("unit pos", getPosASL _unit);
    private _isMuted = IS_MUTED(_unit);
    _unit setRandomLip true;

    ["acre_remoteStartedSpeaking", [_unit, _onRadio, _radioId]] call CBA_fnc_localEvent; // [unit, on radio, radio ID]

    if (!_isMuted) then {
        TRACE_3("REMOTE STARTED SPEAKING",_speakingId,_onRadio,(_unit distance acre_player));
        _unit setVariable [QGVAR(lastSpeakingEventTime), diag_tickTime, false];
        if (_onRadio == 1) then {
            if ([_radioId] call EFUNC(sys_radio,radioExists)) then {
                // Handle rack radios or shared manpack radios that are simultaneously in use.
                if (_radioId in ACRE_ACCESSIBLE_RACK_RADIOS || {_radioId in ACRE_HEARABLE_RACK_RADIOS} || {_radioId in ACRE_EXTERNALLY_USED_MANPACK_RADIOS} || {_radioId in ACRE_ACTIVE_EXTERNAL_RADIOS}) then {
                    ACRE_BLOCKED_TRANSMITTING_RADIOS pushBackUnique _radioId;
                };

                GVAR(speakers) pushBack _unit;
                private _val = [_netId, _speakingId];
                HASH_SET(GVAR(keyedRadioIds), _radioId, _val);
                _unit setVariable [QGVAR(currentSpeakingRadio), _radioId];
                private _speakerRadio = [];
                private _nearRadios = [ACRE_LISTENER_POS, NEAR_RADIO_RANGE] call EFUNC(sys_radio,nearRadios);
                if (EGVAR(sys_zeus,zeusCommunicateViaCamera) && {call FUNC(inZeus)}) then {
                    _nearRadios append ([getPosASL curatorCamera, NEAR_RADIO_RANGE] call EFUNC(sys_radio,nearRadios));
                    _nearRadios = _nearRadios arrayIntersect _nearRadios;
                };
                {
                    if ([_x, "isExternalAudio"] call EFUNC(sys_data,dataEvent)) then {
                        _speakerRadio pushBack _x;
                    };
                } forEach _nearRadios;
                GVAR(nearRadios) = _speakerRadio;
                private _personalRadioList = [] call EFUNC(sys_data,getPlayerRadioList);
                if (_radioId in _personalRadioList && {ACRE_BROADCASTING_RADIOID == ""}) then {
                    ACRE_BROADCASTING_RADIOID = _radioId;
                    // diag_log text format["ASSIGNED ACRE_BROADCASTING_RADIOID REMOTE START: %1", ACRE_BROADCASTING_RADIOID];
                };
                private _okRadios = [[_radioId], _personalRadioList + GVAR(nearRadios), false] call EFUNC(sys_modes,checkAvailability);
                _okRadios = (_okRadios select 0) select 1;

                //_okRadios = _okRadios - [ACRE_BROADCASTING_RADIOID];
                if !(_okRadios isEqualTo []) then {
                    missionNamespace setVariable [_radioId + "_signal_startTime", diag_tickTime];
                    _result = true;
                    GVAR(speaking_cache_valid) = false;
                    GVAR(keyedMicRadios) pushBack _unit;
                    {
                        [_x, "handleBeginTransmission", [_radioId]] call EFUNC(sys_data,transEvent);
                    } forEach _okRadios;
                    if (ACRE_CORE_INIT) then { // Must wait for the map to have finished loading.
                        [_unit, _okRadios] call FUNC(processRadioSpeaker); // Call here to initiate the extension call.
                    };
                };

            } else {
                WARNING_1("Got start speaking event with non-existent radio id: %1",_radioId);
            };
        } else {
            if (_unit call FUNC(inRange)) then {
                GVAR(speakers) pushBack _unit;
            };
            TRACE_1("REMOVING FROM RADIO MICS LIST",GVAR(keyedMicRadios));
            REM(GVAR(keyedMicRadios),_unit);
            HASH_REM(GVAR(keyedRadioIds), _radioId);
        };
    } else {
        TRACE_3("MUTED:", _unit, _isMuted, _netId);
    };



_result
