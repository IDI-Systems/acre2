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

if(isNil QGVAR(monitorAIHandle)) exitWith { false };

if(GVAR(monitorAIHandle) > -1) then {
    [GVAR(monitorAIHandle)] call EFUNC(sys_sync,perFrame_remove);
};

true
