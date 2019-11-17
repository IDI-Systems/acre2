#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles death of unit, primarily for handling local player death.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [player] call acre_sys_core_fnc_onPlayerKilled
 *
 * Public: No
 */

params ["_unit"];

if (_unit == acre_player) then {
    // close any dialogs just to be safe
    closeDialog 0;
    closeDialog 0;
    LOG("enter self death");
    // its ourself, reset our consistent values
    GVAR(globalVolume) = 1.0;
    GVAR(isDeaf) = false;

    acre_player setVariable [QGVAR(isDisabled), false, true];
};

true
