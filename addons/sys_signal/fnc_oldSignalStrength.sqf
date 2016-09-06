/*
 * Author: AUTHOR
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
private ["_receiver", "_transmitter", "_f", "_mW", "_receiverClass", "_transmitterClass", "_resDiv",
            "_baseConfig", "_realRadio", "_txAntenna", "_rxAntenna", "_sinadRating", "_start", "_res",
            "_profile", "_altitudes", "_maxHeight", "_losDif", "_d1", "_txPos", "_txHeight", "_rxPos",
            "_rxHeight", "_d", "_opposite", "_elevation", "_avgObjCount", "_forItu", "_a", "_alt", "_dif",
            "_intersect", "_groundWeave", "_s", "_obj", "_aA", "_size", "_width", "_depth", "_height",
            "_objAlt", "_oc", "_args", "_signal", "_p", "_end", "_total", "_isPersistant"];


TRACE_1("PARAMS TO fnc_testSignalStrength",_this);
_receiver = _this select 0;
_transmitter = _this select 1;
_f = _this select 2;
_mW = _this select 3;
_receiverClass = _this select 4;
_transmitterClass = _this select 5;
_isPersistant = _this select 6;
_resDiv =  ((floor ((_transmitter distance _receiver)*.005) min 10) max 1);
_p = -1;



_baseConfig = inheritsFrom (configFile >> "CfgWeapons" >> _transmitterClass);
_realRadioTx = configName ( _baseConfig );

_baseConfig = inheritsFrom (configFile >> "CfgWeapons" >> _receiverClass);
_realRadioRx = configName ( _baseConfig );
_sinadRating = getNumber (configFile >> "CfgAcreComponents" >> _realRadioRx >> "sinadRating");

_start = COMPAT_diag_tickTime;
_args = [_receiver, _realRadioRx, _transmitter, _realRadioTx, _f];
TRACE_1("data", _args);
_gainData = _args call EFUNC(sys_antenna,getAntennaInfo);
if((count _gainData) < 5) then {
    _gainData = _args call EFUNC(sys_antenna,getAntennaInfo);
};
if((count _gainData) > 5) then {
    _d = (_gainData select 5) distance (_gainData select 4);
    _res = _d/_resDiv;
    // _txPosSum = ((_gainData select 5) select 0) + ((_gainData select 5) select 1) + ((_gainData select 5) select 2);
    // _rxPosSum = ((_gainData select 4) select 0) + ((_gainData select 4) select 1) + ((_gainData select 4) select 2);
    _profile = [];
    //_cached = false;
    //if(_txPosSum != GVAR(lastTxPos) || _rxPosSum != GVAR(lastRxPos)) then {
        _profile = [(_gainData select 5), (_gainData select 4), _res] call FUNC(getTerrainProfile);
        //GVAR(lastProfile) = _profile;
    // } else {
        // _profile = GVAR(lastProfile);
        // _cached = true;
    // };
    // GVAR(lastTxPos) = _txPosSum;
    // GVAR(lastRxPos) = _rxPosSum;

    _altitudes = _profile select 3;
    _maxHeight = -10000;
    _losDif = -100000;
    _d1 = 0;

    _rxHeight = ((_gainData select 4) select 2);
    _txHeight = ((_gainData select 5) select 2);

    _elevation = _gainData select 3;

    _avgObjCount = 0;
    _forItu = [];
    _a = 0;
    _debug = "";
    for "_x" from 0 to (count _altitudes)-1 do {
        _alt = _altitudes select _x;
        _dif = (_alt select 1) * (tan _elevation);
        _intersect = 0;
        if(_txHeight > _rxHeight) then {
            _intersect = _txHeight - (_dif);
        } else {
            _intersect = _txHeight + (_dif);
        };
        _groundWeave = (_intersect - ((_alt select 0) max 0.01));
        //_debug = _debug + format["%1,%2,%3%4", ((_alt select 0) max 0.01), _intersect, _groundWeave, toString [10]];
        if((count (_alt select 2)) > 0) then {
            if(_groundWeave < 10 && _groundWeave > 0) then {
                _s = (_alt select 2);
                _s set[2, 0];

                _obj = nearestObjects [_s, ["All"], ((((_profile select 2)/2) min 50) max 5)];
                _obj = _obj + nearestObjects [_s, [], ((((_profile select 2)/2) min 50) max 5)];
                if((count _obj) > 0) then {
                    _aA = 0;
                    for "_i" from 0 to (50 min ((count _obj)-1)) do {

                        _size = boundingBox (_obj select _i);
                        _width    = (abs ((_size select 0) select 0)) + ((_size select 1) select 0);
                        _depth    = (abs ((_size select 0) select 1)) + ((_size select 1) select 1);
                        _height    = (abs ((_size select 0) select 2)) + ((_size select 1) select 2);
                        _objAlt = ((getPosASL (_obj select _i)) select 2);

                        if(_height >= (2)) then {
                            _aA = _aA + ((_width*_depth)*0.01);
                        };
                    };
                    _a = _a + _aA;
                    _alt set [(count _alt), (count _obj)];
                    _avgObjCount = _avgObjCount + (count _obj);
                } else {
                    _alt set [(count _alt), 0];
                };
            };
        } else {
            _alt set [(count _alt), 0];
        };
        PUSH(_forItu, ARR_4((_intersect max 0.01), ((_alt select 0) max 0.01), (_alt select 1), ((_profile select 0)-(_alt select 1) max 0.01)));
        if(_groundWeave > _maxHeight) then {
            _maxHeight = _groundWeave;
            _losDif = 2.5;
            _d1 = _alt select 1;
        };
    };
    //copyToClipboard _debug;
    _oc = 0;
    _d1 = (_d1 max (_d1+1));

    //_oc = (((_d*0.02) min 55));
    TRACE_1("OC",_oc);
    _oc1 = log(_a)+30;
    TRACE_1("OC1",_oc1);
    _oc = _oc + _oc1;
    _args = [
        _d,
        _f,
        _d1,
        (_profile select 0)-_d1 max 0.01,
        _losDif max 0.01,
        _maxHeight max 0.01,
        _oc,
        _mW,
        (_gainData select 1),
        (_gainData select 0),
        _sinadRating,
        _forItu
    ];
    TRACE_1("ARGS TO SINAD", _args);

    _signal = _args call FUNC(SINAD);
    _p = (_signal select 0);
    _end = COMPAT_diag_tickTime;
    _total = _end - _start;
    if(GVAR(showSignalHint)) then {
        if(!_isPersistant) then {
            COMPAT_hintSilent format["Strength: %1%9 @ %2Mhz\nRx: %3dBm @ %4mW\nAlt: %5m\nDis2D: %6m Dis3D: %7\nTxG: %10 RxG: %11\nAvg Time: %8",
                                _p*100,
                                _f,
                                _signal select 1,
                                _mW,
                                _txHeight,
                                (_profile select 0),
                                _d,
                                (_total),
                                "%",
                                (_gainData select 1),
                                (_gainData select 0)
                              ];
            // ACRE_DEBUG_LOG_LINE set [(count ACRE_DEBUG_LOG_LINE), _p*100];
            // ACRE_DEBUG_LOG_LINE set [(count ACRE_DEBUG_LOG_LINE), _signal select 1];
            // ACRE_DEBUG_LOG_LINE set [(count ACRE_DEBUG_LOG_LINE), (_gainData select 1)];
            // ACRE_DEBUG_LOG_LINE set [(count ACRE_DEBUG_LOG_LINE), (_gainData select 0)];
            // ACRE_DEBUG_LOG_LINE set [(count ACRE_DEBUG_LOG_LINE), _mW];



        };
    };
};
_p
