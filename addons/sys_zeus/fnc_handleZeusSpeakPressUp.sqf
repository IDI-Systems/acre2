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
[GVAR(speakFromZeusHandle)] call CBA_fnc_removePerFrameHandler;
