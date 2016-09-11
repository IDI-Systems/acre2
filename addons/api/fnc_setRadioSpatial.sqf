/*
 * Author: ACRE2Team
 * Sets what spatialization zone the specified radio ID should be in. “LEFT”, “RIGHT” or “CENTER”.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Spatial “LEFT”, “RIGHT” or “CENTER" <STRING>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _success = ["ACRE_PRC148_ID_3", "LEFT" ] call acre_api_fnc_setRadioSpatial;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_radio", "_side"];

if( (isNil "_side") || (isNil "_radio") ) exitWith { false };
if ( !(_radio in ([] call EFUNC(sys_data,getPlayerRadioList))) ) exitWith { false };

if(_side != "LEFT" && _side != "RIGHT" && _side != "CENTER") exitWith { false };

private _spatialReturnValue = false;
_spatialReturnValue = [(_this select 0), _side] call EFUNC(sys_radio,setRadioSpatial);

_spatialReturnValue
