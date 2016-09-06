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

private ["_reflectInfo", "_l", "_Ls", "_deg", "_ratio1", "_ratio2", "_ratio", "_newDistance", "_Rp", "_vectorFromTxToR", "_vectorFromRxtoR", "_dirToRx", "_dirToTx", "_elevToRx", "_elevToTx", "_txGain", "_rxGain", "_sum", "_objectLoss1", "_objectLoss2", "_objectLoss", "_Ltx", "_Lrx", "_Lm"];

params ["_results", "_returns", "_index", "_step", "_f", "_mW"];

_reflectInfo    = _returns select _index;

_reflectInfo params [ "_reflectPos", "_txPos", "_txAntenna", "_rxPos", "_rxAntenna"];

if(_step == 0) then {
    _l = [_txPos, _reflectPos, _f] call FUNC(getItuLoss);
    if(_l < 160) then {
        _results set[_index, [_l, false]];
        _step = 1;
    } else {
        _results set[_index, [-994, true]];
        _step = 3;
    };
} else {
    if(_step == 1) then {
        _Ls = (_results select _index) select 0;
        _l = [_reflectPos, _rxPos, _f] call FUNC(getItuLoss);
        if(_Ls + _l < 150) then {
            _deg = (asin((surfaceNormal _reflectPos) select 2) - asin ((_reflectPos vectorFromTo _rxPos) select 2));
            _ratio1 = cos(_deg);

            _deg = (asin((surfaceNormal _reflectPos) select 2) - asin ((_reflectPos vectorFromTo _txPos) select 2));
            _ratio2 = cos(_deg);
            _ratio = _ratio1*_ratio2;
            // ADDICON(ASLtoATL _reflectPos, str _ratio1 + "*" + str _ratio2 + "=" + str (_ratio*_mW));
            _newDistance = sqrt((_rxPos vectorDistanceSqr _reflectPos) + (_txPos vectorDistanceSqr _reflectPos));

            _Rp = [_newDistance, _f, _mW, _ratio] call FUNC(getFspl);
            _Ls = (_Rp-(_Ls+_l-32));
            if(_Ls > -160) then {
                _results set[_index, [_Ls, false]];
                _step = 2;
            } else {
                _results set[_index, [-996, true]];
                _step = 3;
            };
        } else {
            _results set[_index, [-995, true]];
            _step = 3;
        };
    } else {
        _step = 3;
        _Ls = (_results select _index) select 0;
        _vectorFromTxToR = _txPos vectorFromTo _reflectPos;
        _vectorFromRxtoR = _rxPos vectorFromTo _reflectPos;
        _dirToRx = (((_vectorFromRxtoR select 0) atan2 (_vectorFromRxtoR select 1)) + 360) mod 360;
        _dirToTx = (((_vectorFromTxToR select 0) atan2 (_vectorFromTxToR select 1)) + 360) mod 360;

        _elevToRx = asin (_vectorFromRxtoR select 2);
        _elevToTx = asin (_vectorFromTxToR select 2);

        _txGain = [_rxAntenna, _dirToRx, _elevToTx, _f] call EFUNC(sys_antenna,getGain);
        _rxGain = [_txAntenna, _dirToTx, _elevToRx, _f, (_txGain select 1)] call EFUNC(sys_antenna,getGain);
        _sum = (_txGain select 0) + (_rxGain select 0);

        _objectLoss1 = [_reflectPos, _rxPos, _f] call FUNC(objectLoss);
        _objectLoss2 = [_reflectPos, _txPos, _f] call FUNC(objectLoss);
        _objectLoss = _objectLoss1 + _objectLoss2;

        _Ltx = 3; // Transmitter
        _Lrx = 3; // Receiver

        _Lm = ((random 1) - 0.5) + _objectLoss;

        _Ls = _Ls - _Ltx - _Lrx - _Lm + _sum;

        _results set[_index, [_Ls, true]];

        ADDICON(ASLtoATL _reflectPos, (str _Ls) + "dBm");
        ADDLINECOLOR(_reflectPos, _rxPos, C(1,0,0,1));
        ADDLINECOLOR(_reflectPos, _txPos, C(0,0,1,1));
    };
};
_step;
