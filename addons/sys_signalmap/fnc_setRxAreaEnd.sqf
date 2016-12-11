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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_setRxAreaEnd;
 *
 * Public: No
 */
#include "script_component.hpp"

if (_this select 1 == 0) then {
    _ctrl = _this select 0;
    _ctrl ctrlRemoveEventHandler ["MouseButtonDown", GVAR(rxSetEH)];
    [] call FUNC(clearOverlayMessage);
    _x = _this select 2;
    _y = _this select 3;
    _pos = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [_x, _y];
    _pos set[2, 0];
    with uiNamespace do {
        GVAR(rxAreaEnd) = _pos;
        deleteMarkerLocal QGVAR(rxAreaStartMarker);

        _size = GVAR(rxAreaEnd) vectorDiff GVAR(rxAreaStart);

        if (_size select 0 < 0) then {
            _temp_start = +GVAR(rxAreaStart);
            _temp_end = +GVAR(rxAreaEnd);

            GVAR(rxAreaStart) = [(GVAR(rxAreaStart) select 0) + (_size select 0), GVAR(rxAreaStart) select 1, 0];
            GVAR(rxAreaEnd) = [_temp_start select 0, GVAR(rxAreaEnd) select 1, 0];
            _size = GVAR(rxAreaEnd) vectorDiff GVAR(rxAreaStart);
        };

        if (_size select 1 < 0) then {
            _temp_start = +GVAR(rxAreaStart);
            _temp_end = +GVAR(rxAreaEnd);

            GVAR(rxAreaStart) = [GVAR(rxAreaStart) select 0, (GVAR(rxAreaStart) select 1) + (_size select 1), 0];
            GVAR(rxAreaEnd) = [GVAR(rxAreaEnd) select 0, _temp_start select 1, 0];
            _size = GVAR(rxAreaEnd) vectorDiff GVAR(rxAreaStart);
        };

        _width = _size select 0;
        _height = _size select 1;


        _sampleSize = floor (parseNumber (ctrlText GVAR(sampleSize)));

        if (_width < _sampleSize || _height < _sampleSize) exitWith {
            hintSilent "Indvidual Rx areas must be larger than the sample size in both directions!";
        };

        _xTiles = ceil (_width / TILE_SIZE);
        _yTiles = ceil  (_height / TILE_SIZE);



        for "_x" from 0 to _xTiles-1 do {
            _xScale = ((_width / TILE_SIZE)-(_x)) min 1;
            diag_log text format["x: %1", _xScale];
            for "_y" from 0 to _yTiles-1 do {
                _yScale = ((_height / TILE_SIZE)-(_y)) min 1;

                _start = [(GVAR(rxAreaStart) select 0) + (TILE_SIZE * _x), (GVAR(rxAreaStart) select 1) + (TILE_SIZE * _y), 0];
                _end = [(_start select 0) + (TILE_SIZE * _xScale), (_start select 1) + (TILE_SIZE * _yScale), 0];

                _markerPos = [(_start select 0) + ((TILE_SIZE * _xScale) / 2), (_start select 1) + ((TILE_SIZE * _yScale) / 2)];

                _marker = createMarkerLocal [format["rxarea_%1", (count GVAR(rxAreas))], _markerPos];
                _marker setMarkerSizeLocal [(TILE_SIZE * _xScale) / 2, (TILE_SIZE * _yScale) / 2];
                _marker setMarkerShapeLocal "RECTANGLE";
                _marker setMarkerColorLocal "ColorRed";



                GVAR(rxAreas) pushBack [[+_start, +_end], _marker];

                GVAR(rxAreaList) lbAdd format["%1: [%2, %3]", (count GVAR(rxAreas)), _markerPos select 0, _markerPos select 1];
                GVAR(rxAreaList) lbSetData [(count GVAR(rxAreas)) - 1, str ((count GVAR(rxAreas)) - 1)];
                GVAR(rxAreaList) lbSetCurSel ((count GVAR(rxAreas)) - 1);
                GVAR(rxAreaList) ctrlCommit 0;
            };
        };
    };
};
