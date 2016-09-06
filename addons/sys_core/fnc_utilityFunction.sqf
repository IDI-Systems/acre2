/*
 * Author: AUTHOR
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
    // acre_player sideChat format["ptt: %1", (GVAR(keyboardEvents) select 1)];
    {
        _key = HASH_GET(GVAR(keyboardEvents), _x);
        _kbData = format (["%1,%2,%3,%4,%5,"] + _key);
        // diag_log text format["Setting PTT Key: %1", _kbData];
        ["setPTTKeys", _kbData] call EFUNC(sys_rpc,callRemoteProcedure);
    } forEach HASH_KEYS(GVAR(keyboardEvents));
};
ADDPFH(DFUNC(utilityFuncPFH), 5, []);

/* Used by getPosASLAtDistance (deprecated), to improve accurcay of position.
DFUNC(remotePosPFH) = {
    acre_player setVariable ["ap", (eyePos acre_player), true];
};
ADDPFH(DFUNC(remotePosPFH), 5, []);
*/
[] call FUNC(aliveMonitor);


GVAR(wrongVersionIncrease) = 0;
DFUNC(getPluginVersion) = {
    ["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
};
["getPluginVersion", ","] call EFUNC(sys_rpc,callRemoteProcedure);
ADDPFH(DFUNC(getPluginVersion), 15, []);
