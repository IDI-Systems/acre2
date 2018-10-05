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

player setVariable [QGVAR(inZeus), false, true];

// Save Zeus specator state and restore previous out of Zeus state
private _wasSpectator = player getVariable [QGVAR(wasSpectator), ACRE_IS_SPECTATOR];
player setVariable [QGVAR(wasSpectator), ACRE_IS_SPECTATOR];
[_wasSpectator] call EFUNC(api,setSpectator);

[GVAR(speakFromZeusHandle)] call CBA_fnc_removePerFrameHandler;
