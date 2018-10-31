#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the babel language display name from the language ID.
 *
 * Arguments:
 * 0: Language ID <STRING>
 *
 * Return Value:
 * Language display name <STRING>
 *
 * Example:
 * ["en"] call acre_api_fnc_babelSetSpeakingLanguage;
 *
 * Public: Yes
 */

params [
    ["_languageKey", "", [""]]
];

[_languageKey] call EFUNC(sys_core,getLanguageName);
