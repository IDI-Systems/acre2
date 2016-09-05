//fnc_noApiFunction.sqf
#include "script_component.hpp"

params ["_radioId", "_event"];
diag_log text format["WARNING: Radio event handler function %1:%2 is not defined!", _radioId, _event];
