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

private ["_pos1","_pos2","_interval","_direction","_distance","_intervalDistance",
            "_profile","_pollPos","_alt","_lastPos"];

_pos1 = [];
_pos2 = [];
if(IS_OBJECT((_this select 0))) then {
    _pos1 = getPosASL (_this select 0);
} else {
    _pos1 = (_this select 0);
};
if(IS_OBJECT((_this select 1))) then {
    _pos2 = getPosASL (_this select 1);
} else {
    _pos2 = (_this select 1);
};
_interval = _this select 2;
_direction = ([_pos1, _pos2] call CALLSTACK(LIB_fnc_dirTo));
_distance = [_pos1, _pos2] call CALLSTACK(LIB_fnc_distance2D);
_intervalDistance = 0;
_profile = [];
_alt = [(COMPAT_getTerrainHeightASL _pos1), _intervalDistance, _pos1];

_profile set [(count _profile), _alt];
_lastPos = _pos1;
_intervalDistance = _intervalDistance + _interval;

while{_intervalDistance < _distance} do {
    _pos = [_lastPos, _interval, _direction] call CALLSTACK(LIB_fnc_relPos);
    _alt = [(COMPAT_getTerrainHeightASL _pos), _intervalDistance, _pos];
    _profile set [(count _profile), _alt];
    _intervalDistance = _intervalDistance + _interval;
    _lastPos = _pos;
};


_alt = [(COMPAT_getTerrainHeightASL _pos2), _distance, _pos2];
_profile set [(count _profile), _alt];


[_distance, _direction, _interval, _profile]
