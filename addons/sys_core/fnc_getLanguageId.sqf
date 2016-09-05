//fnc_getLanguageId.sqf
#include "script_component.hpp"

params["_languageKey"];

private _ret = -1;
{
    if((_x select 0) == _languageKey) exitWith {
        _ret = _forEachIndex;
    };
} forEach GVAR(languages);
_ret;
