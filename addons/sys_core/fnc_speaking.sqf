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
#include "script_component.hpp"
GVAR(persistAlive) = 1;
GVAR(lastRadioTime) = time + 0.25;
GVAR(lastKeyCount) = 0;



DFUNC(speakingLoop) = {
    // private _startTime = diag_tickTime;
    // private _rstart = 0;
    // private _rend = 0;

    if (time == 0) exitWith { true; };

    // Call update self
    [] call FUNC(updateSelf);

    private _radioParamsSorted = [[],[]];
    if (GVAR(speaking_cache_valid)) then {
        BEGIN_COUNTER(speaking_loop);
    };

    private _sentMicRadios = [];
    if (count GVAR(keyedMicRadios) > 0) then {
        BEGIN_COUNTER(speaking_loop_with_transmissions);

        // if ((time >= GVAR(lastRadioTime) || {GVAR(lastKeyCount) != count GVAR(keyedMicRadios) })) then {
        BEGIN_COUNTER(signal_code);

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
                    if ((count _params) > 0) then {
                        _params params ["_txId","_rxId","_signalData","_params"];
                        //_params = _params select 3;
                        _radioParamsSorted params ["_radios","_sources"];
                        private _keyIndex = _radios find _rxId;
                        if (_keyIndex == -1) then {
                            _keyIndex = (count _radios);
                            _radios set[_keyIndex, _rxId];
                            _sources set[_keyIndex, []];
                        };
                        _txRadios = _sources select _keyIndex;
                        _txRadios pushBack [_unit,_txId,_signalData,_params];
                        if (EGVAR(sys_signal,showSignalHint)) then {
                            _signalHint = _signalHint + format["%1->%2:\n%3dBm (%4%5)\n", name _unit, _rxId, _signalData select 1, round((_signalData select 0)*100), "%"];
                        };
                    };
                } forEach _returnedRadios;
            };
        } forEach GVAR(keyedMicRadios);
        if (_signalHint != "") then {
            hintSilent ("Current transmissions:\n\n" + _signalHint);
        };

        END_COUNTER(signal_code);

        _radioParamsSorted params ["_radios","_sources"];

        #ifdef ENABLE_PERFORMANCE_COUNTERS
        if ( (count _radios) > 0) then {
            BEGIN_COUNTER(radio_loop);
        };
        #endif

        private _compiledParams = HASH_CREATE;
        {
            private _recRadio = _x;
            if (_recRadio != ACRE_BROADCASTING_RADIOID || GVAR(fullDuplex)) then {
                BEGIN_COUNTER(radio_loop_single_radio);
                private ["_radioVolume", "_volumeModifier", "_on"];
                if (!GVAR(speaking_cache_valid)) then {
                    _radioVolume = [_recRadio, "getVolume"] call EFUNC(sys_data,dataEvent);
                    // _rend = diag_tickTime;
                    _volumeModifier = GVAR(globalVolume);
                    _on = [_recRadio, "getOnOffState"] call EFUNC(sys_data,dataEvent);
                    if (_on == 0) then {
                        _volumeModifier = 0;
                    };
                    HASH_SET(GVAR(coreCache), "volume"+_recRadio, _radioVolume);
                    HASH_SET(GVAR(coreCache), "volumeModifier"+_recRadio, _volumeModifier);
                    HASH_SET(GVAR(coreCache), "on"+_recRadio, _on);
                } else {
                    _radioVolume = HASH_GET(GVAR(coreCache), "volume"+_recRadio);
                    _volumeModifier = HASH_GET(GVAR(coreCache), "volumeModifier"+_recRadio);
                    _on = HASH_GET(GVAR(coreCache), "on"+_recRadio);
                };
                if (_on == 1) then {
                    BEGIN_COUNTER(handleMultipleTransmissions);
                    // if (!GVAR(speaking_cache_valid)) then {
                    private _sourceRadios = _sources select _forEachIndex;
                    private _hearableRadios = [_recRadio, "handleMultipleTransmissions", _sourceRadios] call EFUNC(sys_data,transEvent);
                    if (GVAR(fullDuplex)) then {
                        _hearableRadios = _sourceRadios;
                    };
                        // HASH_SET(GVAR(coreCache), _recRadio + "hmt_cache", _hearableRadios);
                    // } else {
                        // _hearableRadios = HASH_GET(GVAR(coreCache), _recRadio + "hmt_cache");
                    // };
                    END_COUNTER(handleMultipleTransmissions);

                    BEGIN_COUNTER(data_events);

                    // _rstart = diag_tickTime;

                    private _radioPos = [0,0,0];
                    private _attenuate = 1;
                    if ([_recRadio, "isExternalAudio"] call EFUNC(sys_data,dataEvent)) then {
                        _radioPos = [_recRadio, "getExternalAudioPosition"] call EFUNC(sys_data,physicalEvent);
                        _args = [_radioPos, ACRE_LISTENER_POS, acre_player];
                        // there needs to be handling of vehicle attenuation too
                        private _recRadioObject = [_recRadio] call EFUNC(sys_radio,getRadioObject);
                        _attenuate = [_recRadioObject] call EFUNC(sys_attenuate,getUnitAttenuate);
                        _attenuate = (1-_attenuate)^3;
                        _volumeModifier = _args call FUNC(findOcclusion);
                        _volumeModifier = _volumeModifier^3;
                    };

                    END_COUNTER(data_events);

                    BEGIN_COUNTER(hearableRadios);

                    // acre_player sideChat format["_volumeModifier: %1 %2", _volumeModifier];
                    {
                        _on = [_x select 1, "getOnOffState"] call EFUNC(sys_data,dataEvent);
                        if (_on == 1) then {
                            _x params ["_unit","","_signalData","_params"];
                            if (!HASH_HASKEY(_compiledParams, netId _unit)) then {
                                HASH_SET(_compiledParams, netId _unit, []);
                            };
                            private _speakingRadios = HASH_GET(_compiledParams, netId _unit);
                            if ((_params select 3)) then {

                                // Possible sound fix: Always double the distance of the radio for hearing purposes
                                // on external speaker to make it 'distant' like a speaker.
                                // This should be moved to plugin probably.
                                //_radioPos = _radioPos * [2,2,2];
                                _params set[4, _radioPos];
                                _params set[0, _radioVolume*_volumeModifier*_attenuate];
                            } else {
                                _ear = [_recRadio, "getState", "ACRE_INTERNAL_RADIOSPATIALIZATION"] call EFUNC(sys_data,dataEvent);
                                if (isNil "_ear") then {
                                    _ear = 0;
                                };
                                _params set[4, [_ear*2, 0, 0]];

                                // Scale radio volume for headset
                                // I'm not sure if this is the best way or place to do it. But Fuck your Life (tm), i'm doing it here.
                                if (GVAR(lowered) == 1) then {
                                    _radioVolume = _radioVolume * 0.15;
                                };
                                _params set[0, _radioVolume];
                            };
                            _params set[1, (_signalData select 0)];
                            _speakingRadios pushBack _params;
                        };
                    } forEach _hearableRadios;
                    END_COUNTER(hearableRadios);
                };
                END_COUNTER(radio_loop_single_radio);
            };
        } forEach _radios;

        #ifdef ENABLE_PERFORMANCE_COUNTERS
        if ( (count _radios) > 0) then {
            END_COUNTER(radio_loop);
        };
        #endif


        BEGIN_COUNTER(updateSpeakingData_loop);

        // _rstart = diag_tickTime;
        {
            private _unit = objectFromNetId _x;
            if (!isNull _unit) then {
                _sentMicRadios pushBack _unit;
                private _params = HASH_GET(_compiledParams, _x);
                _count = (count _params);
                _canUnderstand = [_unit] call FUNC(canUnderstand);
                _paramArray = ["r", GET_TS3ID(_unit), !_canUnderstand, _count];
                {
                    _paramArray append _x;
                } forEach _params;
                CALL_RPC("updateSpeakingData", _paramArray);
            };
        } forEach HASH_KEYS(_compiledParams);
        // _rend = diag_tickTime;

        END_COUNTER(updateSpeakingData_loop);

        END_COUNTER(speaking_loop_with_transmissions);
    };

    BEGIN_COUNTER(muting);

    {
        private _unit = _x;
        if (!isNull _unit) then {
            if (!IS_MUTED(_unit) && _unit != acre_player) then {
                if (GVAR(enableDistanceMuting) && {(getPosASL _unit) distance ACRE_LISTENER_POS < 300}) then {
                    TRACE_1("Calling processDirectSpeaker", _unit);
                    private _params = [_unit] call FUNC(processDirectSpeaker);
                    CALL_RPC("updateSpeakingData", _params);

                    // if (!(_unit getVariable [QGVAR(isDisabled), false]) ) then {
                        // _sayTime = _unit getVariable [QGVAR(sayTime), time-2];
                        // if ((abs (time-_sayTime)) >= 1) then {
                            // _unit say "acre_lip_sound";
                            // _unit setVariable [QGVAR(sayTime), time, false];
                        // };
                    // };
                } else {
                    if (!(_unit in _sentMicRadios)) then {
                        private _params = ['m', GET_TS3ID(_unit), 0];
                        CALL_RPC("updateSpeakingData", _params);
                    };
                };
            } else {
                if (_unit != acre_player) then {
                    private _params = ['m', GET_TS3ID(_unit), 0];
                    CALL_RPC("updateSpeakingData", _params);
                };
            };
        };
    } forEach GVAR(speakers);
    if (ACRE_IS_SPECTATOR) then {
        {
            _speakingId = _x;
            _volume = GVAR(spectatorVolume);
            if (ACRE_MUTE_SPECTATORS) then {
                _volume = 0;
            };
            private _params = ["s", _speakingId, 0, _volume];
            CALL_RPC("updateSpeakingData", _params);
        } forEach GVAR(spectatorSpeakers);
    };

    END_COUNTER(muting);

    if (GVAR(speaking_cache_valid)) then {
        END_COUNTER(speaking_loop);
    };

    // diag_log text format["t: %1", _rend-_rstart];
    // _end = diag_tickTime;
    // diag_log text format["t: %1ms", (_end-_startTime)*1000];
    GVAR(speaking_cache_valid) = true;
};

GVAR(speakingHandle) = ADDPFH(DFUNC(speakingLoop), 0.06, []);
true
