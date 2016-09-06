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

private ["_pos1", "_pos2", "_pos2p", "_pos1p", "_f", "_resolution", "_multi", "_ituLoss", "_3dDis", "_stepVector", "_nextPos", "_prevPos", "_z", "_2dDis", "_isRising", "_lastAlt", "_lastHighest", "_fGhz", "_ops", "_exit", "_hasIntersected", "_c", "_alt", "_disPos", "_disKm", "_l"];
_pos1 = +(_this select 0);
_pos2 = +(_this select 1);

_pos2p = +_pos2;
_pos1p = +_pos1;
// ADDLINECOLOR(_pos1p, _pos2p, C(1,0,0,1));
_f = _this select 2;
_resolution = 25;
if((count _this) > 3) then {
    _resolution = _this select 3;
};
_multi = 40;
if((count _this) > 4) then {
    _multi = _this select 4;
};

if(!terrainIntersectASL [_pos1, _pos2]) then {
    _resolution = _resolution*4;
};

_ituLoss = 0;

_3dDis = _pos1 vectorDistanceSqr _pos2;


_stepVector = (_pos1 vectorFromTo _pos2) vectorMultiply _resolution;

_nextPos = +_pos1;
_prevPos = _nextPos;
_z = _stepVector select 2;
_pos1 set[2, 0];
_pos2 set[2, 0];



_2dDis = _pos1 vectorDistance _pos2;

_isRising = false;
_lastAlt = -10000;
_lastHighest = -10000;
_fGhz = _f/1000;
_ops = 0;
_exit = false;
_hasIntersected = false;
_c = 1;

while {!_exit} do {
    _ops = _ops + 1;
    // ADDICON(ASLtoATL _prevPos, _prevPos);
    if(_hasIntersected || {terrainIntersectASL [_prevPos, _nextPos]}) then {
        if(!_hasIntersected) then {
            _hasIntersected = true;
            _nextPos = _prevPos;
        };
        _alt = (getTerrainHeightASL _nextPos);

        if(_alt > _lastAlt) then {
            _isRising = true;
        } else {
            if(_isRising) then {
                _isRising = false;
                if(abs(_lastHighest - _lastAlt) >= 5) then {
                    if(_pos1p vectorDistanceSqr _nextPos > _3dDis) then {
                        _exit = true;
                    } else {
                        _lastHighest = _lastAlt;
                        _disPos = +_prevPos;
                        _disPos set[2, 0];
                        _disKm = (_pos1 vectorDistance _disPos)/1000;
                        ADDICON(ASLtoATL _prevPos, _pos1p);
                        _l = ([(_nextPos select 2)-_z, _lastAlt, _disKm, (_2dDis/1000)-_disKm, _fGhz] call FUNC(ITULoss));
                        // diag_log text format["l: %1", _l];
                        _ituLoss = _ituLoss + _l;
                        if((_ituLoss) > 120) then {
                            _exit = true;
                        };
                    };
                };
            };
        };
        _c = _c + 1;
        _lastAlt = _alt;
        if(_c >= _multi) then {
            _c = 1;
            _hasIntersected = false;
            _lastAlt = -10000;
        };
    };
    _prevPos = _nextPos;
    if(_hasIntersected) then {
        _nextPos = _nextPos vectorAdd _stepVector;
    } else {
        if(_pos1p vectorDistanceSqr _nextPos >= _3dDis) then {
            _exit = true;
        } else {
            _nextPos = _nextPos vectorAdd (_stepVector vectorMultiply _multi);
            if(_prevPos vectorDistance _pos2p < _prevPos vectorDistance _nextPos) then {
                _nextPos = _pos2p;
            };
        };
    };
};
if(_ituLoss < 32) then {
    _ituLoss = _ituLoss + (32-_ituLoss);
};
// acre_player sideChat format["ituloss: %1 %2", _ituLoss, _ops];
_ituLoss;
