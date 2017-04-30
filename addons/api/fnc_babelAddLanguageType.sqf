/*
 * Author: ACRE2Team
 * Creates a new language to be used by the babel system.
 *
 * Arguments:
 * 0: Language ID (used internally for identifying the language or specifying languages via other API methods) <STRING>
 * 1: Language display name <STRING>
 *
 * Return Value:
 * Setup succesful <BOOL>
 *
 * Example:
 * ["en", "English"] call acre_api_fnc_babelAddLanguageType;
 *
 * Public: Yes
 */
#include "script_component.hpp"

// Babel is not maintained on non-clients.
if (!hasInterface) exitWith {};

params ["_languageKey", "_languageName"];

[_languageKey, _languageName] call EFUNC(sys_core,addLanguageType);
