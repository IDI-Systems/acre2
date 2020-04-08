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
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

params ["_radioId"];

if (acre_player != acre_current_player) then {
    // Switch radio list to remote controlled unit upon opening that unit's radio from inventory
    // Do not automatically switch on remote control as it is more often that quick control without radios is required
    // Switch can also be done through ACE Interaction Menu
    acre_player = acre_current_player;
    [[ICON_RADIO_CALL], [localize LSTRING(SwitchRadioRemoteControl)]] call CBA_fnc_notify;
};

[_radioId] call EFUNC(sys_radio,openRadio);
