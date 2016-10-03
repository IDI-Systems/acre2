#include "script_component.hpp"
if(hasInterface) then {
    [QGVAR(clientGCRadio), { _this call FUNC(clientGCRadio) }] call CALLSTACK(CBA_fnc_addEventHandler);
    ["acre_updateIdObjects", { _this call FUNC(updateIdObjects) }] call CALLSTACK(CBA_fnc_addEventHandler);
    [QGVAR(restoreInvalidGCData), { _this call FUNC(cloneRadioData) }] call CALLSTACK(CBA_fnc_addEventHandler);
};
