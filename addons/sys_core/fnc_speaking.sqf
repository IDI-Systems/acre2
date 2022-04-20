#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets up the the per frame event handler for processing all the speaking data which in turn will send data to TeamSpeak.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_speaking
 *
 * Public: No
 */

if (time == 0) exitWith {};

// Call update self
[] call FUNC(updateSelf);

private _radioParamsSorted = [[],[]];

#ifdef ENABLE_PERFORMANCE_COUNTERS
    if (GVAR(speaking_cache_valid)) then {
        BEGIN_COUNTER(speaking_loop);
    };
#endif

private _sentMicRadios = [];
if (GVAR(keyedMicRadios) isNotEqualTo []) then {

    #ifdef ENABLE_PERFORMANCE_COUNTERS
        BEGIN_COUNTER(speaking_loop_with_transmissions);
        BEGIN_COUNTER(signal_code);
    #endif

    // if ((time >= GVAR(lastRadioTime) || {GVAR(lastKeyCount) != count GVAR(keyedMicRadios) })) then {
    // GVAR(lastKeyCount) = count GVAR(keyedMicRadios);
    private ["_playerRadios"];
    if (!GVAR(speaking_cache_valid)) then {
        _playerRadios = [] call EFUNC(sys_data,getPlayerRadioList);
        _playerRadios = _playerRadios - GVAR(nearRadios);
        _playerRadios append GVAR(nearRadios);
        HASH_SET(GVAR(coreCache), "playerRadios", _playerRadios);
    } else {
        _playerRadios = HASH_GET(GVAR(coreCache), "playerRadios");
    };
    // GVAR(lastRadioTime) = time + ((0.25*(count _playerRadios)) min 1);
    private _signalHint = "";

    {
        private _unit = _x;
        if (!IS_MUTED(_unit)) then {
            TRACE_1("Calling processRadioSpeaker", _unit);
            private _returnedRadios = [_unit, _playerRadios] call FUNC(processRadioSpeaker);

            {
                private _params = _x;
                if (_params isNotEqualTo []) then {
                    _params params ["_txId", "_rxId", "_signalData", "_params"];

                    _radioParamsSorted params ["_radios", "_sources"];
                    private _keyIndex = _radios find _rxId;
                    if (_keyIndex == -1) then {
                        _keyIndex = count _radios;
                        _radios set [_keyIndex, _rxId];
                        _sources set [_keyIndex, []];
                    };

                    // NOTE: Since sources is an array, and afterwards, the selectedd element is modified, the original array _radioParamsSorted
                    // is also modified. _sources is "passed" by reference
                    private _txRadios = _sources select _keyIndex;
                    _txRadios pushBack [_unit,_txId,_signalData,_params];

                    if (EGVAR(sys_signal,showSignalHint)) then {
                        _signalHint = format ["%1%2->%3:\n%4dBm (%5%6)\n", _signalHint, name _unit, _rxId, _signalData select 1, round((_signalData select 0)*100), "%"];
                    };
                };
            } forEach _returnedRadios;
        };
    } forEach GVAR(keyedMicRadios);
    if (_signalHint != "") then {
        hintSilent ("Current transmissions:\n\n" + _signalHint);
    };

    #ifdef ENABLE_PERFORMANCE_COUNTERS
        END_COUNTER(signal_code);
    #endif

    _radioParamsSorted params ["_radios","_sources"];

    #ifdef ENABLE_PERFORMANCE_COUNTERS
        if (_radios isNotEqualTo []) then {
            BEGIN_COUNTER(radio_loop);
        };
    #endif

    private _compiledParams = HASH_CREATE;
    {
        private _recRadio = _x;
        if (_recRadio != ACRE_BROADCASTING_RADIOID || {GVAR(fullDuplex)} || {(toLower _recRadio) in ACRE_SPECTATOR_RADIOS}) then {
            #ifdef ENABLE_PERFORMANCE_COUNTERS
                BEGIN_COUNTER(radio_loop_single_radio);
            #endif
            private ["_radioVolume", "_volumeModifier", "_on"];
            if (!GVAR(speaking_cache_valid)) then {
                _radioVolume = [_recRadio, "getVolume"] call EFUNC(sys_data,dataEvent);

                _volumeModifier = GVAR(globalVolume);
                _on = [_recRadio, "getOnOffState"] call EFUNC(sys_data,dataEvent);
                if (_on == 0) then {
                    _volumeModifier = 0;
                };
                HASH_SET(GVAR(coreCache), "volume" + _recRadio, _radioVolume);
                HASH_SET(GVAR(coreCache), "volumeModifier" + _recRadio, _volumeModifier);
                HASH_SET(GVAR(coreCache), "on" + _recRadio, _on);
            } else {
                _radioVolume = HASH_GET(GVAR(coreCache), "volume" + _recRadio);
                _volumeModifier = HASH_GET(GVAR(coreCache), "volumeModifier" + _recRadio);
                _on = HASH_GET(GVAR(coreCache), "on" + _recRadio);
            };
            if (_on == 1) then {
                #ifdef ENABLE_PERFORMANCE_COUNTERS
                    BEGIN_COUNTER(handleMultipleTransmissions);
                #endif
                // if (!GVAR(speaking_cache_valid)) then {
                private _sourceRadios = _sources select _forEachIndex;
                private _hearableRadios = [_recRadio, "handleMultipleTransmissions", _sourceRadios] call EFUNC(sys_data,transEvent);
                if (GVAR(fullDuplex) || {(toLower _recRadio) in ACRE_SPECTATOR_RADIOS}) then {
                    _hearableRadios = _sourceRadios;
                };
                // HASH_SET(GVAR(coreCache), _recRadio + "hmt_cache", _hearableRadios);
                // } else {
                    // _hearableRadios = HASH_GET(GVAR(coreCache), _recRadio + "hmt_cache");
                // };
                #ifdef ENABLE_PERFORMANCE_COUNTERS
                    END_COUNTER(handleMultipleTransmissions);
                    BEGIN_COUNTER(data_events);
                #endif

                private _radioPos = [0,0,0];
                private _attenuate = 1;
                private _occlusion = 1;
                if ([_recRadio, "isExternalAudio"] call EFUNC(sys_data,dataEvent)) then {
                    _radioPos = [_recRadio, "getExternalAudioPosition"] call EFUNC(sys_data,physicalEvent);
                    // there needs to be handling of vehicle attenuation too
                    private _recRadioObject = [_recRadio] call EFUNC(sys_radio,getRadioObject);
                    _attenuate = [_recRadioObject] call EFUNC(sys_attenuate,getUnitAttenuate);
                    _attenuate = (1 - _attenuate)^3;
                    _occlusion = [_radioPos, ACRE_LISTENER_POS, _recRadioObject] call FUNC(findOcclusion);
                    _occlusion = _occlusion^3;
                };

                #ifdef ENABLE_PERFORMANCE_COUNTERS
                    END_COUNTER(data_events);
                    BEGIN_COUNTER(hearableRadios);
                #endif

                {
                    _on = [_x select 1, "getOnOffState"] call EFUNC(sys_data,dataEvent);
                    if (_on == 1) then {
                        _x params ["_unit", "", "_signalData", "_params"];
                        if (!HASH_HASKEY(_compiledParams, netId _unit)) then {
                            HASH_SET(_compiledParams, netId _unit, []);
                        };
                        private _speakingRadios = HASH_GET(_compiledParams, netId _unit);
                        if (_params select 3) then { // speaker / loudspeaker
                            // Possible sound fix: Always double the distance of the radio for hearing purposes
                            // on external speaker to make it 'distant' like a speaker.
                            // This should be moved to plugin probably.
                            _params set [4, _radioPos];
                            _params set [0, _radioVolume * _volumeModifier * _attenuate * _occlusion];
                            TRACE_4("volume (loudspeaker)",_params select 0,_radioVolume,_volumeModifier,_attenuate,_occlusion);
                        } else {
                            private _ear = [_recRadio, "getState", "ACRE_INTERNAL_RADIOSPATIALIZATION"] call EFUNC(sys_data,dataEvent);
                            if (isNil "_ear") then {
                                _ear = 0;
                            };
                            _params set [4, [_ear*2, 0, 0]];

                            // Scale radio volume for headset
                            // I'm not sure if this is the best way or place to do it. But Fuck your Life (tm), i'm doing it here.
                            if (GVAR(lowered)) then {
                                _radioVolume = _radioVolume * 0.15;
                            };
                            _params set [0, _radioVolume * _volumeModifier];
                            TRACE_3("volume (normal)",_params select 0,_radioVolume,_volumeModifier);
                        };
                        _params set [1, _signalData select 0];
                        _speakingRadios pushBack _params;
                    };
                } forEach _hearableRadios;

                #ifdef ENABLE_PERFORMANCE_COUNTERS
                    END_COUNTER(hearableRadios);
                #endif
            };

            #ifdef ENABLE_PERFORMANCE_COUNTERS
                END_COUNTER(radio_loop_single_radio);
            #endif
        };
    } forEach _radios;

    #ifdef ENABLE_PERFORMANCE_COUNTERS
        if (_radios isNotEqualTo []) then {
            END_COUNTER(radio_loop);
        };

        BEGIN_COUNTER(updateSpeakingData_loop);
    #endif

    {
        private _unit = objectFromNetId _x;
        if (!isNull _unit) then {
            _sentMicRadios pushBack _unit;
            private _params = HASH_GET(_compiledParams, _x);
            private _canUnderstand = [_unit] call FUNC(canUnderstand);
            private _paramArray = ["r", GET_TS3ID(_unit), !_canUnderstand, count _params];
            _paramArray append (flatten _params);
            ["updateSpeakingData", _paramArray] call EFUNC(sys_rpc,callRemoteProcedure);
        };
    } forEach HASH_KEYS(_compiledParams);

    #ifdef ENABLE_PERFORMANCE_COUNTERS
        END_COUNTER(updateSpeakingData_loop);

        END_COUNTER(speaking_loop_with_transmissions);
    #endif
};

#ifdef ENABLE_PERFORMANCE_COUNTERS
    BEGIN_COUNTER(muting);
#endif

{
    private _unit = _x;
    if (!isNull _unit) then {
        if (!IS_MUTED(_unit) && {_unit != acre_player}) then {
            if (_unit call FUNC(inRange)) then {
                TRACE_1("Calling processDirectSpeaker", _unit);
                private _params = [_unit] call FUNC(processDirectSpeaker);
                ["updateSpeakingData", _params] call EFUNC(sys_rpc,callRemoteProcedure);
            } else {
                if !(_unit in _sentMicRadios) then {
                    ["updateSpeakingData", ["m", GET_TS3ID(_unit), 0]] call EFUNC(sys_rpc,callRemoteProcedure);
                };
            };
        } else {
            if (_unit != acre_player) then {
                ["updateSpeakingData", ['m', GET_TS3ID(_unit), 0]] call EFUNC(sys_rpc,callRemoteProcedure);
            };
        };
    };
} forEach GVAR(speakers);

{
    private _speakingId = _x;

    // Check speaking gods to only allow hearing by the god's target group
    if ((EGVAR(sys_godmode,speakingGods) find _speakingId) != -1) then {
        ["updateSpeakingData", ["g", _speakingId, 0, GVAR(godVolume)]] call EFUNC(sys_rpc,callRemoteProcedure);
    };
} forEach GVAR(godSpeakers);

if (ACRE_IS_SPECTATOR) then {
    {
        private _speakingId = _x;
        private _volume = GVAR(spectatorVolume);
        if (ACRE_MUTE_SPECTATORS) then {
            _volume = 0;
        };
        private _params = ["s", _speakingId, 0, _volume];
        ["updateSpeakingData", ["s", _speakingId, 0, _volume]] call EFUNC(sys_rpc,callRemoteProcedure);
    } forEach GVAR(spectatorSpeakers);
};

#ifdef ENABLE_PERFORMANCE_COUNTERS
    END_COUNTER(muting);

    if (GVAR(speaking_cache_valid)) then {
        END_COUNTER(speaking_loop);
    };
#endif

GVAR(speaking_cache_valid) = true;
