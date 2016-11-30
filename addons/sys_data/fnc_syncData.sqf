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

if (isServer) exitWith { ACRE_DATA_SYNCED = true; };
ACRE_DATA_SYNCED = false;
DFUNC(syncDataPFH) = {
    ACREjips = player;
    INFO("Data Sync Requested.");
    GVAR(dataSyncStart) = diag_tickTime;
    publicVariableServer "ACREjips";
};
[{!isNull player}, DFUNC(syncDataPFH)] call CBA_fnc_waitUntilAndExecute;
