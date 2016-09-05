//fnc_removeHighPriorityId.sqf
#include "script_component.hpp"

params["_id"];

private _index = GVAR(forceHighPriorityIds) find _id;
if(_index != -1) then {
	GVAR(forceHighPriorityIds) set[_index, nil];
};
