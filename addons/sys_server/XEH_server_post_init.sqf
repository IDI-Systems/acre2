#include "script_component.hpp"

if(!isServer) exitWith {};

["acre_checkServerGearDesync", { _this call FUNC(checkServerGearDesync) }] call CALLSTACK(CBA_fnc_addEventHandler);

LOG("Starting radio id handler events");
["acre_getRadioId", { _this call FUNC(onGetRadioId) }] call CALLSTACK(CBA_fnc_addEventHandler);
["acre_acknowledgeId", { _this call FUNC(acknowledgeId) }] call CALLSTACK(CBA_fnc_addEventHandler);
[QGVAR(invalidGarbageCollect), { _this call FUNC(invalidGarbageCollect); }] call CALLSTACK(CBA_fnc_addEventHandler);

ADDPFH(DFUNC(masterIdTracker), 1, []);

ACRE_SERVER_INIT = true;

[QUOTE(GVAR(onSetSpector)), { _this call FUNC(setSpectator) }] call CALLSTACK(CBA_fnc_addEventHandler);
[QUOTE(GVAR(remoteDebugMsg)), { _this call FUNC(remoteDebugMsg) }] call CALLSTACK(CBA_fnc_addEventHandler);
[QUOTE(GVAR(doAddComponentCargo)), { _this call FUNC(doAddComponentCargo) }] call CALLSTACK(CBA_fnc_addEventHandler);

publicVariable "ACRE_SERVER_INIT";

ACRE_FULL_SERVER_VERSION = QUOTE(VERSION);

publicVariable "ACRE_FULL_SERVER_VERSION";
