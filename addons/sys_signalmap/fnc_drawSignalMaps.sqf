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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_drawSignalMaps;
 *
 * Public: No
 */

with uiNamespace do {
    private _mapCtrl = GVAR(mapDisplay) displayCtrl 51;
    private _pos1 = _mapCtrl ctrlMapWorldToScreen [4096,0,0];
    private _pos2 = _mapCtrl ctrlMapWorldToScreen [0,4096,0];

    private _width = (_pos1 select 0)-(_pos2 select 0);
    private _height = (_pos1 select 1)-(_pos2 select 1);
    {
        private _tile = GVAR(mapTiles) select _forEachIndex;
        private _filename = _x select 0;
        private _startPos = _x select 2;

        private _mapStartPos = _mapCtrl ctrlMapWorldToScreen _startPos;

        private _signalMapPos = [_mapStartPos select 0, (_mapStartPos select 1) - _height, _width, _height];

        _tile ctrlSetPosition _signalMapPos;
        _tile ctrlShow true;
        _tile ctrlSetText ("userconfig\" + _filename + ".paa");
        _tile ctrlCommit 0;
    } forEach GVAR(completedAreas);
    {
        private _sample = _x;
        // player sideChat format["%1 %2", _x select 0, _x select 1];
        private _txPos = _sample select 0;
        private _rxPos = _sample select 1;
        drawLine3D [ASLtoATL _txPos, ASLtoATL _rxPos, [0, 1, 0, 1]];
        private _reflections = _sample select 3;
        {
            if (count _x == 0) exitWith {};
            private _point = _x select 0;
            drawLine3D [ASLtoATL _txPos, ASLtoATL _point, [1, 0, 0, 1]];
            drawLine3D [ASLtoATL _point, ASLtoATL _rxPos, [0, 0, 1, 1]];
        } forEach _reflections;
    } forEach GVAR(sampleData);
};
