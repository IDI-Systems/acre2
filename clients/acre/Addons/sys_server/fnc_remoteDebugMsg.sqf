//fnc_remoteDebugMsg.sqf
#include "script_component.hpp"

if(isServer) then {
	diag_log text format["%1 ACRE REMOTE DEBUG MESSAGE: %2", _this];
};
