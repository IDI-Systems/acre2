#include "script_component.hpp"
/*
 * Author: SynixeBrett
 * Handles the speak from zeus camera press up.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call acre_sys_zeus_fnc_handleZeusSpeakPressUp
 *
 * Public: No
 */

DFUNC(doHandleZeusSpeakPressUp) = {
    [GVAR(delayReleasePTT_Handle)] call CBA_fnc_removePerFrameHandler;
    GVAR(delayReleasePTT_Handle) = nil;

    player setVariable [QGVAR(inZeus), false, true];

    // Stop speaking
    ["stopZeusSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);

    // Stop updating Zeus position
    [GVAR(speakFromZeusHandle)] call CBA_fnc_removePerFrameHandler;
    GVAR(speakFromZeusHandle) = nil;
};

GVAR(delayReleasePTT_Handle) = ADDPFH(DFUNC(doHandleZeusSpeakPressUp), ACRE_PTT_RELEASE_DELAY, []);

false
