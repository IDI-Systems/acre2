#include "script_component.hpp"

LOG("Starting radio id handler events");
["acre_getRadioId", { _this call FUNC(onGetRadioId) }] call CALLSTACK(CBA_fnc_addEventHandler);
["acre_acknowledgeId", { _this call FUNC(acknowledgeId) }] call CALLSTACK(CBA_fnc_addEventHandler);
[QGVAR(stopRadioGarbageCollect), { _this call FUNC(stopRadioGarbageCollect) }] call CALLSTACK(CBA_fnc_addEventHandler);
[QGVAR(removeGCQueue), { _this call FUNC(removeGCQueue) }] call CALLSTACK(CBA_fnc_addEventHandler);
[QGVAR(invalidGarbageCollect), { _this call FUNC(invalidGarbageCollect) }] call CALLSTACK(CBA_fnc_addEventHandler);

ADDPFH(FUNC(masterIdTracker), 1, []);

ACRE_SERVER_INIT = true;

[QGVAR(onSetSpector), { _this call FUNC(setSpectator) }] call CALLSTACK(CBA_fnc_addEventHandler);
[QGVAR(doAddComponentCargo), { _this call FUNC(doAddComponentCargo) }] call CALLSTACK(CBA_fnc_addEventHandler);

[QGVAR(openRadioCheck), {_this call FUNC(openRadioCheckRequest)}] call CALLSTACK(CBA_fnc_addEventHandler);
[QGVAR(openRadioUpdate), {_this call FUNC(openRadioUpdateState)}] call CALLSTACK(CBA_fnc_addEventHandler);

publicVariable "ACRE_SERVER_INIT";

ACRE_FULL_SERVER_VERSION = QUOTE(VERSION);

publicVariable "ACRE_FULL_SERVER_VERSION";

// Event handler to remove disconnected clients from the spectator TeamSpeak list
addMissionEventHandler ["PlayerDisconnected", {_this call FUNC(handlePlayerDisconnected);}];
