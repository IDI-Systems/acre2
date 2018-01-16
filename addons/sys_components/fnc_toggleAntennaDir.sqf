/*
 * Author: ACRE2Team
 * Toggles the local player's headset mode (lowered or raised). In spectator this toggles the spectator mute.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_components_fnc_toggleAntennaDir
 *
 * Public: No
 */
#include "script_component.hpp"

TRACE_1("enter", _this);

params ["_dir"];

acre_player setVariable [QEGVAR(sys_core,antennaDirUp), true, true];


if (_dir == 0) then {
    acre_player setVariable [QEGVAR(sys_core,antennaDirUp), false, true];
};
