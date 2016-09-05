//fnc_spectatorOn.sqf
#include "script_component.hpp"

ACRE_IS_SPECTATOR = true;
["acre_sys_server_onSetSpector", [GVAR(ts3id), 1] ] call CALLSTACK(LIB_fnc_globalEvent);
true
