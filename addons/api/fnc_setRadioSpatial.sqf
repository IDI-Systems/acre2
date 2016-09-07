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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
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
