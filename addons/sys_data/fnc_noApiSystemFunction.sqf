//fnc_noApiSystemFunction.sqf
#include "script_component.hpp"

params ["_radioId","_event"];

diag_log text format["WARNING: System event handler function %1 is not defined!", _event];
