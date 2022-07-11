#include "script_component.hpp"
/*
 * Author: Brett Mayson
 * Handles the Zeus interface unload.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call acre_sys_zeus_fnc_handleZeusInterfaceUnload
 *
 * Public: No
 */

// Stop speaking from camera
call FUNC(handleZeusSpeakPressUp);

// Set spectator set as it was before interface open
if (player getVariable [QGVAR(wasSpectator), ACRE_IS_SPECTATOR]) then {
    call EFUNC(sys_core,spectatorOn);
} else {
    call EFUNC(sys_core,spectatorOff);
};
