#include "script_component.hpp"
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

// Save out of Zeus specator state and restore previous Zeus state
private _wasSpectator = player getVariable [QGVAR(wasSpectator), ACRE_IS_SPECTATOR];
player setVariable [QGVAR(wasSpectator), ACRE_IS_SPECTATOR];
// Don't put Zeus back into spectator if they are no longer allowed to
[_wasSpectator && {GVAR(zeusCanSpectate)}] call EFUNC(api,setSpectator);

if (call EFUNC(sys_core,inZeus) && {GVAR(zeusListenViaCamera)}) then {
    player setVariable [QGVAR(inZeus), true, true];
    GVAR(speakFromZeusHandle) = [{
        player setVariable [QGVAR(zeusPosition),
            [getPosASL curatorCamera, getCameraViewDirection curatorCamera],
        true];
    }, 0.3] call CBA_fnc_addPerFrameHandler;
};
