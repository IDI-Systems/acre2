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
#define MAX_REFLECTIONS 1
_startTime = diag_tickTime;
private ["_rxAntenna", "_txPos", "_txAntenna", "_mW", "_f", "_txObj", "_sinadRating", "_waveLength", "_vector", "_rxPos",
        "_distance", "_startPos", "_totalDistance", "_result", "_bpCacheTime", "_bestPlaces", "_times", "_highestRef", "_highestPx",
        "_testCount", "_bpCount", "_tested", "_lastPos", "_returns", "_bpCachedReturns", "_newBpCachedReturns", "_reflectPos", "_x",
        "_vectorFromTxToR", "_newDistance", "_objectLoss1", "_objectLoss2", "_objectLoss", "_vectorFromRtoRx", "_dirToRx", "_dirToTx",
        "_elevToRx", "_elevToTx", "_deg", "_ratio", "_Lfs", "_Ptx", "_Rp", "_txGain", "_rxGain", "_sum", "_resolution", "_ituLoss", "_stepVector",
        "_nextStepPos", "_steps", "_2dDis", "_remainder", "_highest", "_isRising", "_lastAlt", "_lastHighest", "_i", "_alt", "_nz", "_z", "_nx",
        "_ny", "_y", "_fKhz", "_l", "_Ltx", "_Lrx", "_Lm", "_Sl", "_Slp", "_bottom", "_Snd", "_Px", "_txt", "_forEachIndex"];

_rxPos = _this select 0;
_rxAntenna = _this select 1;
_txPos = _this select 2;
_txAntenna = _this select 3;
_mW = _this select 4;
_f = _this select 5;
_txObj = _this select 6;
_sinadRating = _this select 7;

if(!terrainIntersectASL[_txPos, _rxPos]) exitWith { [0,-9999]; };

_waveLength = 300/_f;

_vector = _rxPos vectorFromTo _txPos;
_distance = (_rxPos distance _txPos);
_vector = _vector vectorMultiply (_distance/2);
_startPos = _rxPos vectorAdd _vector;
_totalDistance = 9999999999;
_result = nil;

_mpSkipTime = _txObj getVariable ["acre_multipath_skipTime", diag_tickTime-1];

if(_mpSkipTime < diag_tickTime) then {
    _txObj setVariable ["acre_multipath_skipTime", diag_tickTime+20];
    _txObj setVariable [format["acre_multipath_skip%1", _rxAntenna], false];
    [_txPos, _rxPos, _startPos] call acre_sys_signal_fnc_getBestPlaces;
    acre_player sideChat "CLEAR!";
};
_multiPathSkip = _txObj getVariable [format["acre_multipath_skip%1", _rxAntenna], false];
if(_multiPathSkip) then {
    _skipPos = _txObj getVariable [format["acre_multipath_skipPos%1", _rxAntenna], _rxPos];
    if(_skipPos distance _rxPos > ((_txPos distance _rxPos)/250 max 10)) then {
        acre_player sideChat format["skip!: %1", (_txPos distance _rxPos)/250];
        _txObj setVariable ["acre_multipath_skipTime", diag_tickTime+20];
        if((count ACRE_bestPlaces) == 0) then {
            [_txPos, _rxPos, _startPos] call acre_sys_signal_fnc_getBestPlaces;
        };
        _multiPathSkip = false;
    };
};
if(_multiPathSkip) exitWith { [0, -9991]; };
if((count ACRE_bestPlaces) == 0) then {
    [_txPos, _rxPos, _startPos] call acre_sys_signal_fnc_getBestPlaces;
};
_bestPlaces = ACRE_bestPlaces;
_cachedReturns = _txObj getVariable [format["acre_bp_cachedReturns%1", _txAntenna], []];
if(count _cachedReturns >= GVAR(maxReflections)) then {
    _bestPlaces = _cachedReturns + _bestPlaces;
};



_highestRef = -9999;
_highestPx = 0;
_testCount = 0;
_bpCount = (count _bestPlaces)-1;
_tested = [];
_lastPos = [-1000,-1000,-1000];
_returns = [];

_totalIts = 0;
_newBpCachedReturns = [];
{
    _reflectPos = _x select 0;
    _vectorFromTxToR = _txPos vectorFromTo _reflectPos;

    if(_reflectPos vectorDistanceSqr _rxPos > 10000) then {

        _lastPos = _reflectPos;



        /*
        Terrain Profile Generation
        */
        _ituLoss = 0;
        _ituLoss = [_txPos, _reflectPos, _f, 50] call FUNC(getItuLoss);
        if((_ituLoss+16) < 120) then {
            // _ituLoss2 = ([_reflectPos, _rxPos, _f, 50] call FUNC(getItuLoss))-32;
            // diag_log text format["itu %1 + %2 = %3", _ituLoss, _ituLoss2, _ituLoss+_ituLoss2];
            _ituLoss = _ituLoss + _ituLoss2;
        };

        if((_ituLoss+16) > 120) exitWith {};
        _newDistance = sqrt(((_reflectPos vectorDistanceSqr _rxPos) + (_reflectPos vectorDistanceSqr _txPos)));

        _vectorFromRtoRx = _reflectPos vectorFromTo _rxPos;
        _dirToRx = (((_vectorFromRtoRx select 0) atan2 (_vectorFromRtoRx select 1)) + 360) mod 360;
        _dirToTx = (((_vectorFromTxToR select 0) atan2 (_vectorFromTxToR select 1)) + 360) mod 360;

        _elevToRx = asin (_vectorFromRtoRx select 2);
        _elevToTx = asin (_vectorFromTxToR select 2);

        _txGain = [_rxAntenna, _dirToRx, _elevToTx, _f] call acre_sys_antenna_fnc_getGain;
        _rxGain = [_txAntenna, _dirToTx, _elevToRx, _f, (_txGain select 1)] call acre_sys_antenna_fnc_getGain;
        _sum = (_txGain select 0) + (_rxGain select 0);



        _deg = (asin((surfaceNormal _reflectPos) select 2) - asin (_vectorFromRtoRx select 2));
        _ratio = cos(_deg);


        _Lfs = -27.55 + 20*log(_f) + 20*log(_newDistance);
        _Ptx = 10 * (log ((_mW*_ratio)/1000)) + 30;
        _Rp = _Ptx - _Lfs;

        _objectLoss1 = [_reflectPos, _rxPos, _f] call FUNC(objectLoss);
        _objectLoss2 = [_reflectPos, _txPos, _f] call FUNC(objectLoss);
        _objectLoss = _objectLoss1 + _objectLoss2;



        /*
        Transmitter/Receiver cable/internal loss.
        */
        _Ltx = 5; // Transmitter
        _Lrx = 5; // Receiver

        /*
        Loss from fading, obstruction, noise, etc (including ITU model)
        */
        _Lm = _ituLoss + ((random 1) - 0.5) + _objectLoss;
        _Rp = (_Rp + _sum) - _Ltx - _Lrx - _Lm;





        _highestRef = _highestRef max _Rp;

        _Sl                 = (abs _sinadRating)/2;
        _Slp                   = 0.075;

        _bottom = _sinadRating - (_Sl*_Slp);
        _Snd = abs ((_bottom - (_Rp max _bottom))/_Sl);
        _Px = 100 min (0 max (_Snd*100)); // Bracketed percentage value.
        _Px = _Px/100;
        _txt = format["--%4 rp: %1dBm tl: %2dBm fspl: -%3dBm", _Rp, _ituLoss, _Lfs, _testCount];



        if(_Px > 0) then {
            _testCount = _testCount + 1;
            ADDICON(ASLtoATL (_reflectPos vectorAdd ((surfaceNormal _reflectPos) vectorMultiply 10)), _txt);
            ADDLINECOLOR((_reflectPos vectorAdd ((surfaceNormal _reflectPos) vectorMultiply 10)), _reflectPos, C(1,0,1,1));
            _txt = format["td: %1 dif: %2 r: %3", _newDistance, _deg, _ratio];
            ADDICON(ASLtoATL _reflectPos, _txt);
            ADDLINECOLOR(_txPos, _reflectPos, C(1,0,0,1));
            ADDLINECOLOR(_rxPos, _reflectPos, C(0,1,1,1));
            _newBpCachedReturns pushBack [_reflectPos, _forEachIndex];
        };

        _highestPx = _highestPx max _Px;


    };
    _totalIts = _totalIts + 1;
    if(_testCount >= GVAR(maxReflections)) exitWith { GVAR(maxReflections) = (GVAR(maxReflections) + 1) min 5; };
} forEach _bestPlaces;

if(_testCount == 0 || _highestPx == 0) then {
    _txObj setVariable [format["acre_multipath_skip%1", _rxAntenna], true];
    _txObj setVariable [format["acre_multipath_skipPos%1", _rxAntenna], _rxPos];
    GVAR(maxReflections) = 1;
};
_txObj setVariable [format["acre_bp_cachedReturns%1", _txAntenna], _newBpCachedReturns];

_endTime = diag_tickTime;
acre_player sideChat format["_testCount: %1 %2 %3", _testCount, _totalIts, _endTime - _startTime];
[_highestPx, _highestRef];
