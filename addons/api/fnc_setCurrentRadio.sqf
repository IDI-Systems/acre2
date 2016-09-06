/*
 * Author: AUTHOR
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
 * Public: No
 */

 
#include "script_component.hpp"

params ["_radio"];

if(isNil "_radio") exitWith { false };
if ( !(_radio in ([] call EFUNC(sys_data,getPlayerRadioList))) ) exitWith { false };

[_radio] call EFUNC(sys_radio,setActiveRadio);

true
