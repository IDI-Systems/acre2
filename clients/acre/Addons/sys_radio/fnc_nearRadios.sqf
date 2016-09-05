//fnc_nearRadios.sqf
#include "script_component.hpp"

params["_position", "_radius"];

private _return = [];
{
	private _radioId = _x;
	private _object = HASH_GET(acre_sys_server_objectIdRelationTable, _radioId);
	
	if((getPosASL (_object select 0)) distance _position <= _radius) then {
		PUSH(_return, _radioId);
	};
} forEach HASH_KEYS(acre_sys_server_objectIdRelationTable);

_return;
