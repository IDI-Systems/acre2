//fnc_clientHandleJipData.sqf
#include "script_component.hpp"

BEGIN_COUNTER(JIPSync_Total);

private _data = _this;
diag_log text format["%1 ACRE Data Sync Recieved: %2KB (%3s)", diag_tickTime, (count (toArray (str GVAR(radioData))))/1024, diag_tickTime-GVAR(dataSyncStart)];
GVAR(radioData) = (_data select 0) call FUNC(deserialize);
acre_sys_server_objectIdRelationTable = (_data select 1) call FUNC(deserialize);
ACRE_DATA_SYNCED = true;
diag_log text format["%1 ACRE Data Processing %2 pending events, %3 pending data updates.", diag_tickTime, (count GVAR(pendingSyncEvents)), (count acre_sys_server_pendingIdRelationUpdates)];
{
    _x call FUNC(onDataChangeEvent);
} forEach GVAR(pendingSyncEvents);
{
    _x call EFUNC(sys_server,updateIdObjects);
} forEach acre_sys_server_pendingIdRelationUpdates;
diag_log text format["%1 ACRE Data Sync Complete", diag_tickTime];

END_COUNTER(JIPSync_Total);