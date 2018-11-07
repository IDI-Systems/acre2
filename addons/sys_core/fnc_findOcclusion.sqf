#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Calculates the direct speech occlusion between two positions. Intended to calculate attenuation between the local player and a target unit.
 *
 * Arguments:
 * 0: Start position <ARRAY>
 * 1: End position <ARRAY>
 * 2: Unit <OBJECT>
 *
 * Return Value:
 * Occlusion <NUMBER>
 *
 * Example:
 * [[0,0,0],[11,23,100],unit] call acre_sys_core_fnc_findOcclusion
 *
 * Public: No
 */

params ["_startPos", "_endPos", "_unit"];

private _distance = _startPos distance _endPos;
if (_distance > 150) exitWith { 0; };
if (!lineIntersects [_startPos, _endPos]) exitWith { 1; };
private _vehicleUnit = vehicle _unit;
private _vehiclePlayer = vehicle acre_player;
if (_vehicleUnit isEqualTo _vehiclePlayer) exitWith { 1; };

private _cachedData = (_unit getVariable [QGVAR(occlusionCache), [nil,nil,-1]]);
_cachedData params ["_cachedPos", "_cachedThickness", "_cachedTime"];

private _useCache = false;

if (!isNil "_cachedPos") then {
    if (!_useCache) then {
        if (!lineIntersects [_cachedPos, _startPos, _vehicleUnit, _vehiclePlayer] && {!lineIntersects [_cachedPos, _endPos, _vehicleUnit, _vehiclePlayer]}) then {
            _useCache = true;
        };
    };
} else {
    if (!isNil "_cachedThickness") then {
        _useCache = true;
    };
};

if (_useCache && {_cachedTime < diag_tickTime}) then {
    _useCache = false;
};

if (_useCache) exitWith {
    private _cachedResultDis = -1;
    if (!isNil "_cachedPos") then {
        _cachedResultDis = (_startPos distance _cachedPos)+(_endPos distance _cachedPos);
    };

    //((_distance/_cachedResultDis) max 0) max (1-(_cachedThickness/MAX_THICKNESS));
    ((_distance/_cachedResultDis) max 0) max _cachedThickness;
};

private _totalThickness = 0; //0
private _resultDis = -1;

private _result = 1;
//private _cc = 0;
private _thicknessFactor = 0.0;

// Begin Jaynus additions
private _intersectObjects = lineIntersectsObjs [_startPos, _endPos, _vehicleUnit, _vehiclePlayer, true, 32];


{
    private _typeString = typeOf _x;
    if (_typeString != "") then {

        call {
            if (_typeString isKindOf "House") exitWith { _thicknessFactor = _thicknessFactor + 0.3; };
            if (_typeString isKindOf "LandVehicle") exitWith { _thicknessFactor = _thicknessFactor + 0.07; };
            _thicknessFactor = _thicknessFactor + 0.05;
        };

    } else {
        // No class, default to low factor
        _thicknessFactor = _thicknessFactor + 0.002;
    };

} forEach _intersectObjects;
/*intersectObj = _intersectObjects;
thicknessFactor = _thicknessFactor;
thicknessHits = [];
debugIntersectPoints = [];
checks = 0;*/
private _directAttenuate = 1;
if ((count _intersectObjects) > 0) then { // do occlusion

// End Jaynus Additions

    scopeName "mainSearch";
    private _vec = vectorNormalized (_endPos vectorDiff _startPos);
    private _elev = asin (_vec select 2);
    private _pp = _startPos;
    //distanceP = _distance;
    private _np = _startPos;
    for "_i" from 1 to (((floor _distance)-1) min 50) do {
        _np = _np vectorAdd _vec;
        //checks = checks +1;
        if (lineIntersects [_np, _pp, _vehicleUnit, _vehiclePlayer]) then {

            /*for "_i" from 1 to 10 do {

                private _tnp = _pp vectorAdd (_vec vectorMultiply (_i*0.1));
                checks = checks + 1;
                if (lineIntersects [_pp, _tnp, _vehicleUnit, _vehiclePlayer]) then {
                */
                    //_totalThickness = _totalThickness + _thicknessFactor;
                    _directAttenuate = _directAttenuate * (1 - _thicknessFactor);
                    _thicknessFactor = _thicknessFactor * _thicknessFactor;
                    //debugIntersectPoints pushBack _np;
                    //thicknessHits pushBack _directAttenuate;
                    //if (_totalThickness > MAX_THICKNESS) then {
                    if (_directAttenuate < 0.05) then {
                        _directAttenuate = 0;
                        breakTo "mainSearch";
                    };
                /*};
                _pp = _tnp;
            };*/

        };
        _pp = _np;
    };

    //_dirTo = (((_endPos select 0) - (_startPos select 0)) atan2 ((_endPos select 1) - (_startPos select 1))+360) mod 360;
    private _dirTo = _startPos getDir _endPos; // 1.56
    private _foundPos = nil;
    {
        private _dir = _dirTo+_x;
        private _dirUnit = [ sin _dir, cos _dir, sin _elev];
        {
            //private _dist = _distance*_x;
            private _testPos = _startPos vectorAdd (_dirUnit vectorMultiply (_distance*_x));
            //private _testPos = _startPos getPos [_dist, _dir];
            //_testPos = _testPos vectorAdd [0,0,(_x * (_vec select 2))];
            //_testPos set [2, (_startPos select 2) + (_x * (_vec select 2))]; // (_dist * (sin _elev))
            if (!lineIntersects [_endPos, _testPos, _vehicleUnit, _vehiclePlayer] && {!lineIntersects [_startPos, _testPos, _vehicleUnit, _vehiclePlayer]}) then {
                _foundPos = _testPos;
                breakTo "mainSearch";
            };
        } forEach [0.5, 1, 0.125, 0.75, 0.25];
    } forEach ACRE_TESTANGLES;
    if (isNil "_foundPos") then {
        for "_i" from 1 to 10 do {
            private _testPos = _startPos vectorAdd [0,0,_i*5];

            //_cc = _cc + 1;
            if (lineIntersects [_testPos, _startPos, _vehicleUnit, _vehiclePlayer]) exitWith { };
            //_cc = _cc + 1;
            if (!(lineIntersects [_testPos, _endPos, _vehicleUnit, _vehiclePlayer])) exitWith {
                _distance = (_testPos distance _startPos)+(_testPos distance _endPos);
                if ((_distance*2) < _resultDis) then {
                    _foundPos = _testPos;
                };
            };
        };
    };
    if (!isNil "_foundPos") then {
        _resultDis = (_startPos distance _foundPos)+(_endPos distance _foundPos);
    };

    if (!isNil "_foundPos") then {
        _cachedData = [_foundPos, _directAttenuate, diag_tickTime+0.5+(random 0.25)];
        //_cachedData = [_foundPos, _totalThickness, diag_tickTime+0.5+(random 0.25)];
    } else {
        _cachedData = [nil, _directAttenuate, diag_tickTime+0.5+(random 0.25)];
        //_cachedData = [nil, _totalThickness, diag_tickTime+0.5+(random 0.25)];
    };
    //_result = ((_distance/_resultDis) max 0) max (1-(_totalThickness/MAX_THICKNESS));
    _result = ((_distance/_resultDis) max 0) max _directAttenuate;

};

_cachedData set [2, diag_tickTime+(random 0.33)];
_unit setVariable [QGVAR(occlusionCache), _cachedData, false];

_result;
