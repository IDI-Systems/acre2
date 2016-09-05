//fnc_radioExists.sqf
#include "script_component.hpp"

params["_class"];

private _ret = false;
if(HASH_HASKEY(acre_sys_server_objectIdRelationTable, _class)) then {
	_ret = true;
};
_ret;
