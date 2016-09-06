#include "script_component.hpp"

params ["_rx", "_rxRt", "_tx", "_txRt", "_f"];


TRACE_1("fnc_getAntennaInfo params",_this);
_start = COMPAT_diag_tickTime;

_rxAntennas = [_rxRt] call EFUNC(sys_components,findAntenna);
_txAntennas = [_txRt] call EFUNC(sys_components,findAntenna);

_maxGainSum = -1000000000;
_maxGain = [];

{
    _rxAntennaData = _x;
    _rxAntennaClass = (_rxAntennaData select 0);
    _rxAntenna = (configFile >> "CfgAcreComponents" >> _rxAntennaClass);
    {
        _txAntennaData = _x;
        _txAntennaClass = (_txAntennaData select 0);
        _txAntenna = (configFile >> "CfgAcreComponents" >> _txAntennaClass);
        if((isNil "_rxAntennaClass") || _rxAntennaClass == "") then {
            TRACE_1("_rxAntennaClass is nil or empty", _rxAntennaClass);
        };
        if((isNil "_txAntennaClass") || _txAntennaClass == "") then {
            TRACE_1("_txAntennaClass is nil or empty", _txAntennaClass);
        };
        _rxPos = _rxAntennaData select 2;
        _txPos = _txAntennaData select 2;
        //acre_player sideChat format["tx %1: %2 rx %3: %4", _txRt, _txPos, _rxRt, _rxPos];

        if((_txPos distance _rxPos) == 0) then {
            _rxPos set[2, (_rxPos select 2)+0.1];
        };

        _heading = [_rxPos, _txPos] call FUNC(getElevationXtoY);

        _heading params ["_rxElev","_lineDir"];

        _rxDir = (_lineDir + (getDir _rx)) mod 360;
        _txDir = (_lineDir + (getDir _rx) + 180) mod 360;

        _txElev = _rxElev;

        _txGain = [_txAntennaClass, _txDir, _txElev, _f] call FUNC(getGain);
        _rxGain = [_rxAntennaClass, _rxDir, _rxElev, _f, (_txGain select 1)] call FUNC(getGain);

        _sum = (_txGain select 0) + (_rxGain select 0);
        if(_sum > _maxGainSum) then {
            _maxGainSum = _sum;
            _maxGain = [(_rxGain select 0), (_txGain select 0), _lineDir, _rxElev, _rxPos, _txPos];
        };
    } forEach _txAntennas;
} forEach _rxAntennas;
_maxGain
