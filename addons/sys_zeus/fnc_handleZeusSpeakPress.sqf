/*
 * Author: SynixeBrett
 * Handles the speak from zeus camera press down.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call acre_sys_zeus_fnc_handleZeusSpeakPress
 *
 * Public: No
 */
#include "script_component.hpp"

if (call EFUNC(sys_core,inZeus) && {!ACRE_IS_SPECTATOR}) then {
    player setVariable [QGVAR(inZeus), true, true];
    GVAR(speakFromZeusHandle) = [{
        player setVariable [QGVAR(zeusPosition),
            [getPosASL curatorCamera, getCameraViewDirection curatorCamera],
        true];
    }, 0.3] call CBA_fnc_addPerFrameHandler;
};
