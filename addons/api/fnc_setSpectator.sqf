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

if (!hasInterface) exitWith {false};

params ["_spectVariable"];

if(!IS_BOOL(_spectVariable)) exitWith { false };
if(_spectVariable) then {
    [] call EFUNC(sys_core,spectatorOn);
} else {
    [] call EFUNC(sys_core,spectatorOff);
};
true
