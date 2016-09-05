//fnc_checkServerGearDesync.sqf
#include "script_component.hpp"

params ["_player"];

if(!("ACRE_TestGearDesyncItem" in (items _player))) then {
	["acre_handleDesyncCheck", [_player, true]] call CALLSTACK(LIB_fnc_globalEvent);
} else {
	["acre_handleDesyncCheck", [_player, false]] call CALLSTACK(LIB_fnc_globalEvent);
};	
