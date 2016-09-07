#include "script_component.hpp"

NO_DEDICATED;




// radio claiming handler
[QUOTE(GVAR(returnRadioId)), { _this call FUNC(onReturnRadioId) }] call CALLSTACK(LIB_fnc_addEventHandler);
//[QUOTE(GVAR(returnReplaceRadioId)), { [(_this select 0), (_this select 1), (_this select 2)] call FUNC(onReturnReplacementRadioId) }] call CALLSTACK(LIB_fnc_addEventHandler);

["acre_handleDesyncCheck", { _this call FUNC(handleDesyncCheck) }] call CALLSTACK(LIB_fnc_addEventHandler);

// main inventory thread
[] call FUNC(monitorRadios); // OK
