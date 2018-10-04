#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Babel add a new language.
 *
 * Arguments:
 * 0: Language key name <STRING>
 * 1: Language display name <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["en", "English"] call acre_sys_core_fnc_addLanguageType
 *
 * Public: No
 */

params ["_languageKey", "_languageName"];

GVAR(languages) pushBack [_languageKey, _languageName];
