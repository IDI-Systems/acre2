//fnc_getLanguageName.sqf
#include "script_component.hpp"

params["_languageKey"];

private _ret = "";
if(IS_NUMBER(_languageKey)) then {
	_ret = (GVAR(languages) select _languageKey) select 1;
} else {
	{
		if((_x select 0) == _languageKey) exitWith {
			_ret = _x select 1;
		};
	} forEach GVAR(languages);
};
_ret
