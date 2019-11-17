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
 * [ARGUMENTS] call acre_sys_gui_fnc_inventoryListMouseDown;
 *
 * Public: No
 */

if ((_this select 1) == 1) then {
    ACRE_HOLD_OFF_ITEMRADIO_CHECK = true;
    acre_player unassignItem "ItemRadioAcreFlagged";
    acre_player removeItem "ItemRadioAcreFlagged";
};
