//fnc_getLanguageId.sqf
#include "script_component.hpp"
params ["_languageKey"];

[_languageKey] call EFUNC(sys_core,getLanguageId);