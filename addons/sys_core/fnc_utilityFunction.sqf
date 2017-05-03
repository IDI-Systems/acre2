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
#include "script_component.hpp"

FUNC(utilityFuncPFH) = {
    ["setVoiceCurveModel", format["%1,%2,", ACRE_VOICE_CURVE_MODEL, ACRE_VOICE_CURVE_SCALE]] call EFUNC(sys_rpc,callRemoteProcedure);
};
ADDPFH(FUNC(utilityFuncPFH), 5, []);

[] call FUNC(aliveMonitor);


FUNC(getPluginVersion) = {
    ["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
};
["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
ADDPFH(FUNC(getPluginVersion), 15, []);
