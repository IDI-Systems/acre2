#include "script_component.hpp"
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
 * [player] call acre_sys_components_fnc_getAntennaDirMan
 *
 * Public: No
 */

private ["_forwardV", "_upV"];
params ["_obj"];

// This is a hack fix for vehicles having funky up vectors when people are inside...
if (vehicle _obj == _obj) then {
    // These vectors are in model space (it is assumed these will never be parallel)
    private _spineMV = (_obj selectionPosition "Spine3") vectorFromTo (_obj selectionPosition "Neck");
    private _shoulderMV = (_obj selectionPosition "leftshoulder") vectorFromTo (_obj selectionPosition "rightshoulder");

    if (EGVAR(sys_core,automaticAntennaDirection)) then {
        private _spinePolar = _spineMV call cba_fnc_vect2polar;
        _spinePolar set [2, ((_spinePolar select 2) max 55) min 90];
        _spineMV = _spinePolar call cba_fnc_polar2vect;
    } else {
        if (_obj getVariable [QEGVAR(sys_core,antennaDirUp), false]) then {
            // rotate spine vector arround the shoulder vector
            _spineMV = [_spineMV, _shoulderMV, 50] call CBA_fnc_vectRotate3D;
        };
    };

    private _baseASL = AGLtoASL (_obj modelToWorld [0,0,0]);  // convert from model vector to world
    _upV = _baseASL vectorFromTo AGLtoASL (_obj ModelToWorld _spineMV);
    _forwardV = _baseASL vectorFromTo AGLtoASL (_obj ModelToWorld (_spineMV vectorCrossProduct _shoulderMV));

    /*
    * In order to debug and visualize the antenna direction this function needs to be called every frame.
    * This can be done by a PerFrameHandler via Debug Console:
    * ` [{[player] call acre_sys_components_fnc_getAntennaDirMan},0,[]] call CBA_fnc_addPerFrameHandler`
    * In addition uncomment #define DRAW_ANTENNA_POS in the script_component.hpp
    */
    #ifdef DRAW_ANTENNA_POS
        private _spinePos = _obj modelToWorldVisual (_obj selectionPosition "Spine3");
        drawLine3D [_spinePos, ASLtoAGL ((AGLtoASL _spinePos) vectorAdd _forwardV), [1,0,0,1]];
        drawLine3D [_spinePos, ASLtoAGL ((AGLtoASL _spinePos) vectorAdd _upV), [0,0,1,1]];
    #endif
} else {
    _forwardV = vectorDir (vehicle _obj);
    _upV = vectorUp (vehicle _obj);
};
[_forwardV, _upV];
