/*
 * Author: ACRE2Team
 * Gets the babel language display name from the language key.
 *
 * Arguments:
 * 0: Language key <STRING>
 *
 * Return Value:
 * Language display name <STRING>
 *
 * Example:
 * ["en"] call acre_api_fnc_babelSetSpeakingLanguage;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_languageKey"];

[_languageKey] call EFUNC(sys_core,getLanguageName);
