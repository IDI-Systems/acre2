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
    ["setVoiceCurveModel", format["%1,%2,", ACRE_VOICE_CURVE_MODEL, ACRE_VOICE_CURVE_SCALE]] call EFUNC(sys_rpc,callRemoteProcedure);
};
[DFUNC(utilityFuncPFH), 5, []] call CBA_fnc_addPerFrameHandler;

[] call FUNC(aliveMonitor);


[DFUNC(updateVOIPInfo), 15, []] call CBA_fnc_addPerFrameHandler;
