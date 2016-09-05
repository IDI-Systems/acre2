//fnc_radioObjectsSame.sqf
#include "script_component.hpp"

params["_class"];

private _ret = false;
if(HASH_HASKEY(acre_sys_server_objectIdRelationTable, _class)) then {
    if((HASH_GET(acre_sys_server_objectIdRelationTable, _class) select 0) == (HASH_GET(acre_sys_server_objectIdRelationTable, _class) select 1)) then {
        _ret = true;
    };
};
_ret;
