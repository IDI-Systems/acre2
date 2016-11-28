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
 * [ARGUMENTS] call acre_sys_components_fnc_getAntennaDirMan.sqf
 *
 * Public: No
 */
#include "script_component.hpp"

 private ["_forwardV", "_upV"];
 params ["_obj"];
 //@TODO: This is a hack fix for vehicles having funky up vectors when people are inside...
 if(vehicle _obj == _obj) then {
     _spinePos = (_obj selectionPosition "Spine3");
     _upV = _spinePos vectorFromTo (_obj selectionPosition "Neck");

     _upP = _upV call cba_fnc_vect2polar;
     _upP set[2, (_upP select 2)-90];
     _forwardV = _upP call cba_fnc_polar2vect;

     _forwardV = (ATLtoASL (_obj modelToWorldVisual _spinePos)) vectorFromTo (ATLtoASL (_obj modelToWorldVisual (_spinePos vectorAdd _forwardV)));
     _upV = (ATLtoASL (_obj modelToWorldVisual _spinePos)) vectorFromTo (ATLtoASL (_obj modelToWorldVisual (_spinePos vectorAdd _upV)));
 } else {
     _forwardV = vectorDir (vehicle _obj);
     _upV = vectorUp (vehicle _obj);
 };
 [_forwardV, _upV];
