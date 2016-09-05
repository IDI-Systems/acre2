//fnc_loadConfig.sqf
#include "script_component.hpp"

params["_file", "_namespace"];

private _data = [_file] call FUNC(parseIni);
// diag_log text format["Loaded config: %1", _data];
private _section = "";

{
	if(IS_STRING(_x)) then {
		_section = _x;
	} else {
		_x params ["_key","_val"];

		missionNamespace setVariable ["ACRE" + _namespace + _section + _key, _val];
	};
} forEach _data;
true
