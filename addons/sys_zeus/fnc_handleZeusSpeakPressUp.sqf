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

if (!canSuspend) exitWith {0 spawn FUNC(handleZeusSpeakPressUp)};

sleep 0.5;
player setVariable [QGVAR(inZeus), false, true];

// Restore previous out of Zeus state
[player getVariable [QGVAR(wasSpectator), ACRE_IS_SPECTATOR]] call EFUNC(api,setSpectator);

// Stop updating Zeus position
[GVAR(speakFromZeusHandle)] call CBA_fnc_removePerFrameHandler;
