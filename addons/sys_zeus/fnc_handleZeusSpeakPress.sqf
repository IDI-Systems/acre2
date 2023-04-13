#include "script_component.hpp"
/*
 * Author: Brett Mayson
 * Handles the speak from Zeus camera press down.
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


if (ACRE_IS_SPECTATOR) exitWith {
    [LSTRING(NoCameraSpeakInSpectator)] call FUNC(showMessage);
    false
};

if (call EFUNC(sys_core,inZeus) && {GVAR(zeusCommunicateViaCamera)}) then {
    GVAR(keyDownWait) = true;
    player setVariable [QGVAR(inZeus), true, true];

    // Start speaking
    ["startZeusSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);

    // Update Zeus position
    GVAR(speakFromZeusHandle) = [{
        player setVariable [QGVAR(zeusPosition),
            [getPosASL curatorCamera, getCameraViewDirection curatorCamera],
        true];
    }, ZEUS_POSITION_FREQUENCY] call CBA_fnc_addPerFrameHandler;
};

false
