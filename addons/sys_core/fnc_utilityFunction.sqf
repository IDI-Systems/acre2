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
ADDPFH(DFUNC(utilityFuncPFH), 5, []);

[] call FUNC(aliveMonitor);


DFUNC(getPluginVersion) = {
    ["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
};
["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
ADDPFH(DFUNC(getPluginVersion), 15, []);
