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
TRACE_1("enter", _this);

params ["_radioId"];

// Switch radio list to remote controlled unit upon opening that unit's radio from inventory
// Do not automatically switch on remote control as it is more often that quick control without radios is required
// Switch can also be done through ACE Interaction Menu
acre_player = acre_current_player;
[[ICON_RADIO_CALL], [localize LSTRING(SwitchRadioRemoteControl)]] call CBA_fnc_notify;

[_radioId] call EFUNC(sys_radio,openRadio);
