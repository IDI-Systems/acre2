//fnc_updateMode.sqf
#include "script_component.hpp"

params["_newVal", "_entry"];
_entry params ["_key", "_oldVal"];

[GVAR(currentRadioId), "setStateCritical", [_key, _newVal]] call EFUNC(sys_data,dataEvent);
