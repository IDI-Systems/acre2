#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_signalmap_fnc_setTxPositionStart;
 *
 * Public: No
 */

if (_this select 1 == 0) then {
    ["<t align='center'>Click on the map to set the Tx Position</t>"] call FUNC(showOverlayMessage);
    GVAR(txSetPosEH) = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["MouseButtonDown", {call FUNC(setTxPositionEnd)}];
};
