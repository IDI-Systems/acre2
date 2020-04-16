#include "script_component.hpp"
/*
 * Author: SynixeBrett
 * Handles the speak from Zeus camera press up.
 * Restores spectator state at the end of speaking
 * (should be disabled on exiting Zeus interface to prevent race conditions due to delays here).
 *
 * Arguments:
 * 0: Restore spectator state <BOOL> (default: true)
 *
 * Return Value:
 * None
 *
 * Example:
 * call acre_sys_zeus_fnc_handleZeusSpeakPressUp
 *
 * Public: No
 */

params [["_restoreSpectator", true, [true]]];

DFUNC(doHandleZeusSpeakPressUp) = {
    params ["_restoreSpectator", "_pfhID"];

    [_pfhID] call CBA_fnc_removePerFrameHandler;

    player setVariable [QGVAR(inZeus), false, true];

    // Stop speaking
    ["stopZeusSpeaking", ""] call EFUNC(sys_rpc,callRemoteProcedure);

    if (_restoreSpectator) then {
    };

    // Stop updating Zeus position
    [GVAR(speakFromZeusHandle)] call CBA_fnc_removePerFrameHandler;
    GVAR(speakFromZeusHandle) = nil;
};

ADDPFH(DFUNC(doHandleZeusSpeakPressUp), ACRE_PTT_RELEASE_DELAY, _restoreSpectator);

false
