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

BEGIN_COUNTER(JIPSync_Total);

private _data = _this;
INFO("Data Sync Received: %1KB (%2s).",(count (toArray (str GVAR(radioData))))/1024,diag_tickTime-GVAR(dataSyncStart));
GVAR(radioData) = (_data select 0) call FUNC(deserialize);
acre_sys_server_objectIdRelationTable = (_data select 1) call FUNC(deserialize);
ACRE_DATA_SYNCED = true;
INFO("Data Processing. %1 pending events, %2 pending data updates.",count GVAR(pendingSyncEvents), count acre_sys_server_pendingIdRelationUpdates);
{
    _x call FUNC(onDataChangeEvent);
} forEach GVAR(pendingSyncEvents);
{
    _x call EFUNC(sys_server,updateIdObjects);
} forEach acre_sys_server_pendingIdRelationUpdates;
INFO("Data Sync Complete.")

END_COUNTER(JIPSync_Total);
