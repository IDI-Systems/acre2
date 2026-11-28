#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets up some utility per frame event handlers.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_utilityFunction
 *
 * Public: No
 */

DFUNC(utilityFuncPFH) = {
    ["settings:curve_model", [ACRE_VOICE_CURVE_MODEL]] call EFUNC(sys_io,ext);
};
[DFUNC(utilityFuncPFH), 5, []] call CBA_fnc_addPerFrameHandler;

[] call FUNC(aliveMonitor);


