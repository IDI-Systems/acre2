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
    
    drawIcon3D ["a3\ui_f\data\gui\Rsc\RscDisplayArsenal\radio_ca.paa", [1,1,1,1], _spinePos, 1, 1, 45, "Spine", 1, 0.05, "TahomaB"];

    _upV = _spinePos vectorFromTo (_obj modelToWorldVisual (_obj selectionPosition "Neck"));

    private _upP = _upV call cba_fnc_vect2polar;
    //hint format ["%1\n%2", _upV, _upP];
    
    if (EGVAR(sys_core,automaticAntennaDirection)) then {
        private _upP = _upV call cba_fnc_vect2polar;
        _upP set [2, ((_upP select 2) max 55) min 90];
        _upV = _upP call cba_fnc_polar2vect; 
        //hint format ["%1\n%2", _upV, _upP];
    } else {
        if (_obj getVariable [QEGVAR(sys_core,antennaDirUp), false]) then {
            private _upP = _upV call cba_fnc_vect2polar;
            _upP set [2, ((_upP select 2) + 50)];
            _upV = _upP call cba_fnc_polar2vect; 
            //hint format ["%1\n%2", _upV, _upP];
        };
    };

    private _forwardP = _upV call cba_fnc_vect2polar;
    _forwardP set [2, (_forwardP select 2) - 90]; 
    _forwardV = _forwardP call cba_fnc_polar2vect; 

    _forwardV = (ATLtoASL _spinePos) vectorFromTo (ATLtoASL (_spinePos vectorAdd _forwardV));
    _upV = (ATLtoASL _spinePos) vectorFromTo (ATLtoASL (_spinePos vectorAdd _upV));

    //drawLine3D [_spinePos, _spinePos vectorAdd _forwardV, [1,0,0,1]]; 
    //drawLine3D [_spinePos, _spinePos vectorAdd _upV, [0,0,1,1]]; 

} else {
    _forwardV = vectorDir (vehicle _obj);
    _upV = vectorUp (vehicle _obj);
};
[_forwardV, _upV];
