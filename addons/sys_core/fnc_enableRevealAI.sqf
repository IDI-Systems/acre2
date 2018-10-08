#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Enables AI hearing of direct speech.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_enableRevealAI
 *
 * Public: No
 */

if (GVAR(revealToAI)) then {
    GVAR(monitorAIHandle) = ADDPFH(DFUNC(monitorAI_PFH), 0.5, []);
};
