//fnc_syncData.sqf
#include "script_component.hpp"

if(isServer) exitWith { ACRE_DATA_SYNCED = true; };
ACRE_DATA_SYNCED = false;
DFUNC(syncDataPFH) = {
	if(!isNull player) then {
		ACREjips = player;
		diag_log text format["%1 ACRE Data Sync Requested", diag_tickTime];
		GVAR(dataSyncStart) = diag_tickTime;
		publicVariableServer "ACREjips";
		[(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
	};
};
ADDPFH(DFUNC(syncDataPFH), 0, []);
