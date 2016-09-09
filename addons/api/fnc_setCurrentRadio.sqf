/*
 * Author: ACRE2Team
 * Sets the currently active radio by radio ID.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * _success = ["ACRE_PRC148_ID_7"] call acre_api_fnc_setCurrentRadio;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_radio"];

if(isNil "_radio") exitWith { false };
if ( !(_radio in ([] call EFUNC(sys_data,getPlayerRadioList))) ) exitWith { false };

[_radio] call EFUNC(sys_radio,setActiveRadio);

true
