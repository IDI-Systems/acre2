#include "script_component.hpp"

if (hasInterface) then {
    // radio claiming handler
    [QGVAR(returnRadioId), { _this call FUNC(onReturnRadioId) }] call CALLSTACK(CBA_fnc_addEventHandler);

    // main inventory thread
    [] call FUNC(monitorRadios); // OK
};
