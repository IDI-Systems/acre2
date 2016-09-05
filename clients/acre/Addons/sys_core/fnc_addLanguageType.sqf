//fnc_addLanguageType.sqf
#include "script_component.hpp"

params ["_languageKey", "_languageName"];

PUSH(GVAR(languages), ARR_2(_languageKey, _languageName));
