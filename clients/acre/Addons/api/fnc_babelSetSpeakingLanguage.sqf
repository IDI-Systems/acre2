//fnc_setSpeakingLanguage.sqf
#include "script_component.hpp"
params ["_languageKey"];

[_languageKey] call EFUNC(sys_core,setSpeakingLanguage);