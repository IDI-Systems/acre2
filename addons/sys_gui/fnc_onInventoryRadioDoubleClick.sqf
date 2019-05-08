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

params ["_object","_container","_radioId"];

// When a radio is opened set acre_player to the current player
acre_player = acre_current_player;

[_radioId] call EFUNC(sys_radio,openRadio);
