#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * This function handles stopping the AI reveal check.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [] call acre_sys_core_fnc_disableRevealAI
 *
 * Public: No
 */

if (isNil QGVAR(monitorAIHandle)) exitWith { false };

if (GVAR(monitorAIHandle) > -1) then {
    [GVAR(monitorAIHandle)] call CBA_fnc_removePerFrameHandler;
};

true
