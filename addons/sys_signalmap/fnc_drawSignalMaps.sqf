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
#include "script_component.hpp"

 with uiNamespace do {
    _mapCtrl = (GVAR(mapDisplay) displayCtrl 51);
    _pos1 = _mapCtrl ctrlMapWorldToScreen [4096,0,0];
    _pos2 = _mapCtrl ctrlMapWorldToScreen [0,4096,0];

    _width = (_pos1 select 0)-(_pos2 select 0);
    _height = (_pos1 select 1)-(_pos2 select 1);
    {
        _tile = GVAR(mapTiles) select _forEachIndex;
        _filename = _x select 0;
        _startPos = _x select 2;

        _mapStartPos = _mapCtrl ctrlMapWorldToScreen _startPos;

        _signalMapPos = [(_mapStartPos select 0), (_mapStartPos select 1)-_height, _width, _height];

        _tile ctrlSetPosition _signalMapPos;
        _tile ctrlShow true;
        _tile ctrlSetText "userconfig\" + _filename + ".paa";
        _tile ctrlCommit 0;
    } forEach GVAR(completedAreas);
    {
        _sample = _x;
        // player sideChat format["%1 %2", _x select 0, _x select 1];
        _txPos = _sample select 0;
        _rxPos = _sample select 1;
        drawLine3D [ASLtoATL _txPos, ASLtoATL _rxPos, [0, 1, 0, 1]];
        _reflections = _sample select 3;
        {
            _reflection = _x;
            if (count _reflection == 0) exitWith {};
            _point = _reflection select 0;
            drawLine3D [ASLtoATL _txPos, ASLtoATL _point, [1, 0, 0, 1]];
            drawLine3D [ASLtoATL _point, ASLtoATL _rxPos, [0, 0, 1, 1]];
        } forEach _reflections;
    } forEach GVAR(sampleData);

};
