/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

DFUNC(utilityFuncPFH) = {
    ["setVoiceCurveModel", format["%1,%2,", ACRE_VOICE_CURVE_MODEL, ACRE_VOICE_CURVE_SCALE]] call EFUNC(sys_rpc,callRemoteProcedure);
};
ADDPFH(DFUNC(utilityFuncPFH), 5, []);

[] call FUNC(aliveMonitor);


GVAR(wrongVersionIncrease) = 0;
DFUNC(getPluginVersion) = {
    ["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
};
["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
ADDPFH(DFUNC(getPluginVersion), 15, []);
