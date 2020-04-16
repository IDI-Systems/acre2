#include "script_component.hpp"
/*
 * Author: SynixeBrett
 * Handles the Zeus interface load.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call acre_sys_zeus_fnc_handleZeusInterfaceLoad
 *
 * Public: No
 */

// Save spectator state for later reset on interface close
player setVariable [QGVAR(wasSpectator), ACRE_IS_SPECTATOR];
