#include "script_component.hpp"
/*
 * Author: Brett Mayson
 * Handles the speak from Zeus camera press up.
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
    params ["", "_pfhID"];

    [_pfhID] call CBA_fnc_removePerFrameHandler;

    player setVariable [QGVAR(inZeus), false, true];

    // Stop speaking
    ["stopZeusSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);

    // Stop updating Zeus position
    [GVAR(speakFromZeusHandle)] call CBA_fnc_removePerFrameHandler;
    GVAR(speakFromZeusHandle) = nil;
};

[DFUNC(doHandleZeusSpeakPressUp), ACRE_PTT_RELEASE_DELAY, []] call CBA_fnc_addPerFrameHandler;

false
