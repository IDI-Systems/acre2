//fnc_addHighPriorityId.sqf
#include "script_component.hpp"

params ["_id"];

if(!(_id in GVAR(forceHighPriorityIds))) then {
	private _found = false;
	for "_i" from 0 to (count GVAR(forceHighPriorityIds))-1 do {
		private _checkId = GVAR(forceHighPriorityIds) select _i;
		if(isNil "_checkId") exitWith {
			GVAR(forceHighPriorityIds) set[_i, _id];
			_found = true;
		};
	};
	if(!_found) then {
		PUSH(GVAR(forceHighPriorityIds), _id);
	};
};
