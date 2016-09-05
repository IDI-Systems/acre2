//fnc_checkSetup.sqf
#include "script_component.hpp"
private["_ret"];

if(isDedicated) then {
	_ret = [] call FUNC(checkServer);
} else {
	_ret = [] call FUNC(checkClient);
};

_ret