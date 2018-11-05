#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the babel language key from the display name.
 *
 * Arguments:
 * 0: Language display name <STRING>
 *
 * Return Value:
 * Language ID <STRING>
 *
 * Example:
 * ["English"] call acre_api_fnc_babelGetLanguageId;
 *
 * Public: Yes
 */


params [
    ["_languageKey", "", [""]]
];

if (_languageKey isEqualTo "") exitWith {false};

[_languageKey] call EFUNC(sys_core,getLanguageId);
