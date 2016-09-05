//fnc_addLanguageType.sqf
#include "script_component.hpp"

// Babel is not maintained on non-clients.
if (!hasInterface) exitWith {};

params ["_languageKey", "_languageName"];

[_languageKey, _languageName] call EFUNC(sys_core,addLanguageType);