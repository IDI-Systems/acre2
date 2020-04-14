#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Calculates the information required by TeamSpeak for a radio speaker.
 *
 * Arguments:
 * 0: Unit to process <OBJECT>
 * 1: List of radio classnames <ARRAY>
 *
 * Return Value:
 * Parameters to send to TeamSpeak  <ARRAY>
 *
 * Example:
 * [unit,["ACRE_PRC343_ID_1"]] call acre_sys_core_fnc_processRadioSpeaker
 *
 * Public: No
 */

#ifdef ENABLE_PERFORMANCE_COUNTERS
    BEGIN_COUNTER(process_radio_speaker);
#endif

private ["_okRadios", "_functionName"];

params ["_unit","_playerRadios"];
TRACE_2("",_unit,_playerRadios);

private _radioId = _unit getVariable [QGVAR(currentSpeakingRadio), ""];
if (_radioId == "") exitWith { false };

// Debug #638
if (isNil "_radioId") exitWith {
    WARNING_1("reserved variable debug 1 - report on GitHub! [%1]",_radioId);
    false
};

// @todo if Underwater Radios are implemented
//if (ACRE_LISTENER_DIVE == 1) exitWith { false };

private _params = [];
#ifdef ENABLE_PERFORMANCE_COUNTERS
    BEGIN_COUNTER(okradio_check);
#endif
private _returns = [];
if (!GVAR(speaking_cache_valid)) then {
    _okRadios = [[_radioId], _playerRadios, false] call EFUNC(sys_modes,checkAvailability);

    #ifdef ENABLE_PERFORMANCE_COUNTERS
        END_COUNTER(okradio_check);
    #endif
    _okRadios = (_okRadios select 0) select 1;

    // Debug #638
    if (isNil "_radioId") exitWith {
        WARNING_3("reserved variable debug 2 - report on GitHub! [%1-%2-%3]",_radioId,_okRadios,_playerRadios);
        false
    };

    private _transmittingRadioData = [_radioId, "getCurrentChannelData"] call EFUNC(sys_data,dataEvent);
    private _mode = HASH_GET(_transmittingRadioData, "mode");
    _functionName = getText(configFile >> "CfgAcreRadioModes" >> _mode >> "speaking");
    HASH_SET(GVAR(coreCache), "okRadios"+_radioId, _okRadios);
    HASH_SET(GVAR(coreCache), "modefunction"+_radioId, _functionName);

} else {
    _okRadios = HASH_GET(GVAR(coreCache), "okRadios"+_radioId);
    _functionName = HASH_GET(GVAR(coreCache), "modefunction"+_radioId);
};


if !(_okRadios isEqualTo []) then {
    #ifdef ENABLE_PERFORMANCE_COUNTERS
        BEGIN_COUNTER(okradio_loop);
    #endif
    {
        private _cachedSampleTime = _unit getVariable [format["ACRE_%1CachedSampleTime", _x], -1];

        if (time > _cachedSampleTime || {!GVAR(speaking_cache_valid)}) then {
            #ifdef ENABLE_PERFORMANCE_COUNTERS
                BEGIN_COUNTER(signal_mode_function);
            #endif
            private _returnData = [_unit, _radioid, acre_player, _x] call CALLSTACK_NAMED((missionNamespace getVariable _functionName), _functionName);
            // DATA STRUCTURE: _returnData = [txRadioId, rxRadioId, signalQuality, distortionModel]
            #ifdef ENABLE_PERFORMANCE_COUNTERS
                END_COUNTER(signal_mode_function);
            #endif
            private _eventReturn = [_x, "handleSignalData", +_returnData] call EFUNC(sys_data,transEvent);
            if (!isNil "_eventReturn") then {
                _returnData = _eventReturn;
            };
            _unit setVariable [format["ACRE_%1CachedSampleData", _x], _returnData];
            _returnData params ["_transmittingRadioId","_receivingRadioid","_signalQuality","_signalDb","_signalModel"];

            private _nextTime = time + 0.2;
            if (_signalDb isEqualTo -992) then { _nextTime = 0; }; // force recheck next time as data hasn't returned yet.
            _unit setVariable [format["ACRE_%1CachedSampleTime", _x], _nextTime];


            private _radioVolume = [_receivingRadioid, "getVolume"] call EFUNC(sys_data,dataEvent);
            _radioVolume = [_x, _radioVolume] call EFUNC(sys_intercom,modifyRadioVolume);
            _radioVolume = _radioVolume * GVAR(globalVolume);
            // acre_player sideChat format["rv: %1", _radioVolume];
            private _isLoudspeaker = [_receivingRadioid, "isExternalAudio"] call EFUNC(sys_data,dataEvent);
            private _spatialArray = [0,0,0];
            if (!_isLoudspeaker) then {
                private _spatial = [_receivingRadioid, "getSpatial"] call EFUNC(sys_data,dataEvent);
                _spatialArray = [_spatial, 0, 0];
            };
            // FULL DUPLEX radios, shouldn't be able to hear themselves.

            _params = [_transmittingRadioId, _receivingRadioid, [_signalQuality, _signalDb], [_radioVolume, _signalQuality, _signalModel, _isLoudspeaker, _spatialArray]];
            _unit setVariable ["ACRE_%1CachedSampleParams"+_x, _params];
        } else {
            _params = _unit getVariable ["ACRE_%1CachedSampleParams"+_x, []];
        };
        if (!GVAR(fullDuplex) || {_x != _radioid}) then {
            _returns pushBack _params;
        };
    } forEach _okRadios;
    #ifdef ENABLE_PERFORMANCE_COUNTERS
        END_COUNTER(okradio_loop);
    #endif
};
#ifdef ENABLE_PERFORMANCE_COUNTERS
    END_COUNTER(process_radio_speaker);
#endif

_returns
