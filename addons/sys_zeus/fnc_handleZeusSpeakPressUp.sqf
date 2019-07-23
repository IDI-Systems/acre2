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

[{!(GVAR(keyDownWait))}, {
    player setVariable [QGVAR(inZeus), false, true];

    // Stop speaking
    ["stopZeusSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);

    // Restore previous out of Zeus state
    if (player getVariable [QGVAR(wasSpectator), ACRE_IS_SPECTATOR]) then {
        call EFUNC(sys_core,spectatorOn);
    } else {
        call EFUNC(sys_core,spectatorOff);
    };

    // Stop updating Zeus position
    [GVAR(speakFromZeusHandle)] call CBA_fnc_removePerFrameHandler;
}] call CBA_fnc_waitUntilAndExecute;

true
