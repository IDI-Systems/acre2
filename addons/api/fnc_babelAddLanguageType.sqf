#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Creates a new language to be used by the babel system.
 *
 * Arguments:
 * 0: Language ID (used internally for identifying the language or specifying languages via other API methods) <STRING>
 * 1: Language display name <STRING>
 *
 * Return Value:
 * Setup successful <BOOL>
 *
 * Example:
 * ["en", "English"] call acre_api_fnc_babelAddLanguageType;
 *
 * Public: Yes
 */

// Babel is not maintained on non-clients.
if (!hasInterface) exitWith {};

params [
    ["_languageKey", "", [""]],
    ["_languageName", "", [""]]
];

if (_languageKey isEqualTo "" || {"_languageName" isEqualTo ""}) exitWith {false};

[_languageKey, _languageName] call EFUNC(sys_core,addLanguageType);
