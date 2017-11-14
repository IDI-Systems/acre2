#include "script_component.hpp"

if (!hasInterface) exitWith {};

[QGVAR(clientGCRadio), { _this call FUNC(clientGCRadio) }] call CALLSTACK(CBA_fnc_addEventHandler);
["acre_updateIdObjects", { _this call FUNC(updateIdObjects) }] call CALLSTACK(CBA_fnc_addEventHandler);

[QGVAR(intentToGarbageCollect), { _this call FUNC(clientIntentToGarbageCollect) }] call CALLSTACK(CBA_fnc_addEventHandler);

[QGVAR(openRadioCheckResult), { _this call FUNC(openRadioCheckResult) }] call CALLSTACK(CBA_fnc_addEventHandler);
