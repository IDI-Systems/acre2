//fnc_spectatorOff.sqf
#include "script_component.hpp"

ACRE_IS_SPECTATOR = false;
["acre_sys_server_onSetSpector", [GVAR(ts3id), 0] ] call CALLSTACK(LIB_fnc_globalEvent);
true
