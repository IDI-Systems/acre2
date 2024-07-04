#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_data_fnc_clientHandleJipData
 *
 * Public: No
 */

#ifdef ENABLE_PERFORMANCE_COUNTERS
    BEGIN_COUNTER(JIPSync_Total);
#endif

private _data = _this;
if (ACRE_DEBUG_DATA_SYNC > 0) then {
    INFO_2("Data Sync Received: %1KB (%2s).",(count (toArray (str GVAR(radioData))))/1024,diag_tickTime-GVAR(dataSyncStart));
} else {
    INFO_1("Data Sync Received (%1s).",diag_tickTime-GVAR(dataSyncStart));
};
GVAR(radioData) = (_data select 0) call FUNC(deserialize);
EGVAR(sys_server,objectIdRelationTable) = (_data select 1) call FUNC(deserialize);
ACRE_DATA_SYNCED = true;
INFO_2("Data Processing. %1 pending events - %2 pending data updates.",count GVAR(pendingSyncEvents),count EGVAR(sys_server,pendingIdRelationUpdates));
{
    _x call FUNC(onDataChangeEvent);
} forEach GVAR(pendingSyncEvents);
{
    _x call EFUNC(sys_server,updateIdObjects);
} forEach EGVAR(sys_server,pendingIdRelationUpdates);
INFO("Data Sync Complete.");

#ifdef ENABLE_PERFORMANCE_COUNTERS
    END_COUNTER(JIPSync_Total);
#endif
