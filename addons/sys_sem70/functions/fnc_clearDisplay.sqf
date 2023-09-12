#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_sem70_fnc_clearDisplay
 *
 * Public: No
 */

#define RADIO_CTRL(var1) (_display displayCtrl var1)

params ["_display"];
 {
    RADIO_CTRL(_x) ctrlSetText "";
} forEach [301, 302, 303, 304, 305]; // purge.
