/*
 * Author: ACRE2Team
 * Calculates the antenna direction
 *
 * Arguments:
 * 0: Object to calculate the antenna direction for <OBJECT>
 *
 * Return Value:
 * Vector data for forward direction and upright direction <ARRAY>
 *
 * Example:
 * [player] call acre_sys_components_getAntennaDirMan
 *
 * Public: No
 */
#include "script_component.hpp"

private ["_forwardV", "_upV"];
params ["_obj"];

//@TODO: This is a hack fix for vehicles having funky up vectors when people are inside...
if (vehicle _obj == _obj) then {
    private _spinePos = _obj modelToWorldVisual (_obj selectionPosition "Spine3");
    _upV = _spinePos vectorFromTo (_obj modelToWorldVisual (_obj selectionPosition "Neck"));
    private _upP = _upV call cba_fnc_vect2polar;
    
    _upV = [_obj, _upV] call FUNC(getAntennaUpVector);

    private _forwardP = _upV call cba_fnc_vect2polar;
    _forwardP set [2, (_forwardP select 2) - 90]; 
    _forwardV = _forwardP call cba_fnc_polar2vect; 

    _forwardV = (ATLtoASL _spinePos) vectorFromTo (ATLtoASL (_spinePos vectorAdd _forwardV));
    _upV = (ATLtoASL _spinePos) vectorFromTo (ATLtoASL (_spinePos vectorAdd _upV));

    /*
    * In order to debug and visualize the antenna direction this function needs to be called every frame.
    * This can be done by a PerFrameHandler via Debug Console:
    * ` [{[player] call acre_sys_components_getAntennaDirMan},0,[]] call CBA_fnc_addPerFrameHandler`
    * In addition uncomment #define DRAW_ANTENNA_POS in the script_component.hpp
    */
    #ifdef DRAW_ANTENNA_POS
        drawLine3D [_spinePos, _spinePos vectorAdd _forwardV, [1,0,0,1]]; 
        drawLine3D [_spinePos, _spinePos vectorAdd _upV, [0,0,1,1]];
    #endif
} else {
    _forwardV = vectorDir (vehicle _obj);
    _upV = vectorUp (vehicle _obj);
};
[_forwardV, _upV];
