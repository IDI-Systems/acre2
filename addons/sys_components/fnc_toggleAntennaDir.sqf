/*
 * Author: ACRE2Team
 * Toggles the player's antenna direction (alignment).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * -
 *
 * Example:
 * [] call acre_sys_components_fnc_toggleAntennaDir
 *
 * Public: No
 */
#include "script_component.hpp"

TRACE_1("enter", _this);

//params ["_dir"];

private _dir = acre_player getVariable [QEGVAR(sys_core,antennaDirUp), false];

if (_dir) then {
    acre_player setVariable [QEGVAR(sys_core,antennaDirUp), false, true];
    [localize ELSTRING(sys_core,AntennaDirStraight)] call EFUNC(sys_core,displayNotification);
} else {
    acre_player setVariable [QEGVAR(sys_core,antennaDirUp), true, true];
    [localize ELSTRING(sys_core,AntennaDirBent)] call EFUNC(sys_core,displayNotification);
};