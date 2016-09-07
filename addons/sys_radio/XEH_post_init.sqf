#include "script_component.hpp"

NO_DEDICATED;



// setup CBA keys for moving the radio from left to right ear and center
// [QUOTE(ADDON), "RadioSpatial_Left", { ["LEFT"] call FUNC(handleRadioSpatialKeyPressed) }] call CALLSTACK(LIB_fnc_addKeyHandlerFromConfig);
// [QUOTE(ADDON), "RadioSpatial_Right", { ["RIGHT"] call FUNC(handleRadioSpatialKeyPressed) }] call CALLSTACK(LIB_fnc_addKeyHandlerFromConfig);
// [QUOTE(ADDON), "RadioSpatial_Center", { ["CENTER"] call FUNC(handleRadioSpatialKeyPressed) }] call CALLSTACK(LIB_fnc_addKeyHandlerFromConfig);

// radio claiming handler
[QUOTE(GVAR(returnRadioId)), { _this call FUNC(onReturnRadioId) }] call CALLSTACK(LIB_fnc_addEventHandler);
//[QUOTE(GVAR(returnReplaceRadioId)), { [(_this select 0), (_this select 1), (_this select 2)] call FUNC(onReturnReplacementRadioId) }] call CALLSTACK(LIB_fnc_addEventHandler);

["acre_handleDesyncCheck", { _this call FUNC(handleDesyncCheck) }] call CALLSTACK(LIB_fnc_addEventHandler);

// main inventory thread
[] call FUNC(monitorRadios); // OK
