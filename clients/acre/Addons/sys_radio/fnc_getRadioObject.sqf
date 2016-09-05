//fnc_getRadioObject.sqf
#include "script_component.hpp"

private ["_ret"];
params["_class"];

_ret = nil;
if(HASH_HASKEY(acre_sys_server_objectIdRelationTable, _class)) then {
	_ret = (HASH_GET(acre_sys_server_objectIdRelationTable, _class) select 0);
};
_ret;
