//fnc_setSpeakingLanguage.sqf
#include "script_component.hpp"

params["_languageKey"];

private _ret = false;
{
	if((_x select 0) == _languageKey) exitWith {
		ACRE_CURRENT_LANGUAGE_ID = _forEachIndex;
		_ret = true;
	};
} forEach GVAR(languages);

_ret;
