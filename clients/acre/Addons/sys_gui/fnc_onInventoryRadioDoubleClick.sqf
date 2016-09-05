//#define DEBUG_MODE_FULL
#include "script_component.hpp"
TRACE_1("enter", _this);

params["_object","_container","_radioId"];

[_radioId] call acre_sys_radio_fnc_openRadio;