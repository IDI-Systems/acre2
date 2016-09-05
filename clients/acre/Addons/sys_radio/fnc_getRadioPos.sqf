//fnc_getRadioPos.sqf
#include "script_component.hpp"

params["_class"];

private _ret = [0,0,0];
if(HASH_HASKEY(acre_sys_server_objectIdRelationTable, _class)) then {
	_ret = getPosASL (HASH_GET(acre_sys_server_objectIdRelationTable, _class) select 0);
};
_ret;
