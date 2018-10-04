#include "script_component.hpp"
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

if (_this select 1 != 0) exitWith {};

with uiNamespace do {
    private _mapCtrl = (GVAR(mapDisplay) displayCtrl 51);
    private _clickPos = _mapCtrl ctrlMapScreenToWorld [_this select 2, _this select 3];
    _clickPos set[2, 0];
    private _foundArea = nil;
    {
        private _startPos = _x select 2;
        private _endPos = _x select 3;
        if (_clickPos select 0 >= _startPos select 0 && _clickPos select 1 >= _startPos select 1 &&
            _clickPos select 0 <= _endPos select 0 && _clickPos select 1 <= _endPos select 1) exitWith {
                _foundArea = _x;
        };
    } forEach GVAR(completedAreas);
    if (isNil "_foundArea") exitWith {
        GVAR(sampleData) = [];
    };
    private _id = _foundArea select 0;
    private _sampleSize = _foundArea select 1;
    private _startPos = _foundArea select 2;
    private _endPos = _foundArea select 3;

    private _size = _endPos vectorDiff _startPos;

    private _offset = _clickPos vectorDiff _startPos;
    private _indexOffset = [floor ((_offset select 0)/_sampleSize), floor ((_offset select 1)/_sampleSize)];
    private _extents = [floor ((_size select 0)/_sampleSize), floor ((_size select 1)/_sampleSize)];

    if (_indexOffset select 0 < _extents select 0 && _indexOffset select 1 < _extents select 1) then {
        // player sideChat format["found: %1", _indexOffset];

        private _args = [_id, _indexOffset select 0, _indexOffset select 1, _extents select 0, _extents select 1];
        private _result = [];
        with missionNamespace do {
            //IGNORE_PRIVATE_WARNING ["_result", "_args"];
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
