/*
 * Author: ACRE2Team
 * Toggles the player's antenna direction (alignment).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_components_fnc_toggleAntennaDir
 *
 * Public: No
 */
#include "script_component.hpp"

private _dir = acre_player getVariable [QEGVAR(sys_core,antennaDirUp), false];

// We need to set player variable globally cause we need to check for the antenna direction on every client
if (_dir) then {
    acre_player setVariable [QEGVAR(sys_core,antennaDirUp), false, true];
    [localize ELSTRING(sys_core,AntennaDirStraight)] call EFUNC(sys_core,displayNotification);
} else {
    acre_player setVariable [QEGVAR(sys_core,antennaDirUp), true, true];
    [localize ELSTRING(sys_core,AntennaDirBent)] call EFUNC(sys_core,displayNotification);
};
