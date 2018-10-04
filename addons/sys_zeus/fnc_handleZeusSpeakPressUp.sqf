/*
 * Author: SynixeBrett
 * Handles the speak from zeus camera press up
 *
 * Public: No
 */
#include "script_component.hpp"

player setVariable [QGVAR(inZeus), false, true];
[GVAR(speakFromZeusHandle)] call CBA_fnc_removePerFrameHandler;
