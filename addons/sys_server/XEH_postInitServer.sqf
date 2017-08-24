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

publicVariable "ACRE_SERVER_INIT";

ACRE_FULL_SERVER_VERSION = QUOTE(VERSION);

publicVariable "ACRE_FULL_SERVER_VERSION";

// Event handler to remove disconnected clients from the spectator teamspeak list.
private _id = addMissionEventHandler ["PlayerDisconnected",{
    private _ownerId = _this select 4;
    private _idx = ACRE_SPECTATORS_A3_CLIENT_ID_LIST find _ts3Id;
    while {_idx != -1} do {
        ACRE_SPECTATORS_LIST deleteAt _idx;
        ACRE_SPECTATORS_A3_CLIENT_ID_LIST deleteAt _idx;
        _idx = ACRE_SPECTATORS_A3_CLIENT_ID_LIST find _ts3Id;
    };
    publicVariable "ACRE_SPECTATORS_LIST";
}];