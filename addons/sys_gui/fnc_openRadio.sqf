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
 * [ARGUMENTS] call acre_sys_gui_fnc_openRadio
 *
 * Public: No
 */

params ["_radioId"];

if (acre_player != acre_current_player) then {
    // Switch voice source to remote controlled unit upon opening that unit's radio from inventory
    // otherwise undefined behaviour might happen due to uninitialized radios
    acre_player = acre_current_player;
    [[ICON_RADIO_CALL], [localize ELSTRING(sys_zeus,Remote)]] call CBA_fnc_notify;
};

[_radioId] call EFUNC(sys_radio,openRadio);
