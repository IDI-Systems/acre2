//fnc_getDefaultState.sqf
#include "script_component.hpp"

private ["_value"];
params ["_id", "_default"];

_value = [GVAR(currentRadioId), "getState", _id] call EFUNC(sys_data,dataEvent);
if(isNil "_value") exitWith {
    _default;
};
_value;
