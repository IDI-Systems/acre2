//fnc_getSpokenLanguages.sqf
#include "script_component.hpp"

private _list = [];

{
    PUSH(_list, ((GVAR(languages) select _x) select 0));
} forEach ACRE_SPOKEN_LANGUAGES;
_list
