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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_onMapClick;
 *
 * Public: No
 */
#include "script_component.hpp"

if (_this select 1 != 0) exitWith {};

with uiNamespace do {
    _mapCtrl = (GVAR(mapDisplay) displayCtrl 51);
    _clickPos = _mapCtrl ctrlMapScreenToWorld [_this select 2, _this select 3];
    _clickPos set[2, 0];
    _foundArea = nil;
    {
        _startPos = _x select 2;
        _endPos = _x select 3;
        if (_clickPos select 0 >= _startPos select 0 && _clickPos select 1 >= _startPos select 1 &&
            _clickPos select 0 <= _endPos select 0 && _clickPos select 1 <= _endPos select 1) exitWith {
                _foundArea = _x;
        };
    } forEach GVAR(completedAreas);
    if (isNil "_foundArea") exitWith {
        GVAR(sampleData) = [];
    };
    _id = _foundArea select 0;
    _sampleSize = _foundArea select 1;
    _startPos = _foundArea select 2;
    _endPos = _foundArea select 3;

    _size = _endPos vectorDiff _startPos;

    _offset = _clickPos vectorDiff _startPos;
    _indexOffset = [floor ((_offset select 0)/_sampleSize), floor ((_offset select 1)/_sampleSize)];
    _extents = [floor ((_size select 0)/_sampleSize), floor ((_size select 1)/_sampleSize)];

    if (_indexOffset select 0 < _extents select 0 && _indexOffset select 1 < _extents select 1) then {
        // player sideChat format["found: %1", _indexOffset];

        _args = [_id, _indexOffset select 0, _indexOffset select 1, _extents select 0, _extents select 1];
        _result = [];
        with missionNamespace do {
            _result = ["signal_map_get_sample_data", _args] call EFUNC(sys_core,callExt);
        };
        GVAR(sampleData) = [];
        if (!isNil "_result") then {
            if ((count _result) > 0) then {
                // player sideChat format["res: %1", _result select 2];
                GVAR(sampleData) pushBack _result;
            };
        };
    };
};
