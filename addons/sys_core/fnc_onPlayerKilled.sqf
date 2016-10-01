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
 * Public: No
 */
#include "script_component.hpp"

params["_unit"];

if(_unit == acre_player) then {
    // close any dialogs just to be safe
    closeDialog 0;
    closeDialog 0;
    LOG("enter self death");
    // its ourself, reset our consistent values
    GVAR(globalVolume) = 1.0;
    GVAR(isDeaf) = false;

    acre_player setVariable[QGVAR(isDisabled), false, true];
};

true
