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

private ["_txPos", "_rxPos", "_index", "_returns", "_txAntenna", "_rxAntenna", "_highPos", "_visPos", "_rxHighPos", "_txHighPos", "_bestPlaces", "_rPos", "_x", "_v2t", "_v2r", "_add"];
    _txPos = _this select 0;
    _rxPos = _this select 1;
    _index = _this select 2;
    _returns = _this select 3;
    _txAntenna = _this select 4;
    _rxAntenna = _this select 5;

    _highPos = (GVAR(reflections) select _index) select 0;
    _visPos = [_highPos select 0, _highPos select 1, (_highPos select 2)+200];
    _rxHighPos = [_rxPos select 0, _rxPos select 1, (_rxPos select 2)+200];
    _txHighPos = [_txPos select 0, _txPos select 1, (_txPos select 2)+200];
    // ADDICON(ASLtoATL _highPos, _highPos);
    if(!terrainIntersectASL [_visPos, _rxHighPos] &&
    {!terrainIntersectASL [_visPos, _txHighPos]}) then {
        _bestPlaces = (GVAR(reflections) select _index) select 1;
        {
            _rPos = _x;
            _v2t = (_rPos vectorFromTo _txPos) vectorMultiply 5;
            _v2r = (_rPos vectorFromTo _rxPos) vectorMultiply 5;
            if(!terrainIntersectASL [_rPos, _rPos vectorAdd _v2t] &&
            {!terrainIntersectASL [_rPos, _rPos vectorAdd _v2r]}
            ) exitWith {
                _add = true;
                {
                    if((_x select 0) vectorDistanceSqr _rPos <= 2500) exitWith {
                        _add = false;
                    };
                } forEach _returns;
                if(_add) then {
                    // ADDICON(ASLtoATL _rPos, _rPos);
                    _returns pushBack [_rPos, _txPos, _txAntenna, _rxPos, _rxAntenna];
                };
            };
        } forEach _bestPlaces;
    };
