//fnc_getSpeakingLanguageId.sqf
#include "script_component.hpp"

private _ret = ACRE_CURRENT_LANGUAGE_ID;

if((count GVAR(languages)) == 0) then {
	_ret = 0;
};
_ret;
