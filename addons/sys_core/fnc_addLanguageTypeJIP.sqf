#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Babel add a new language when the current language count is equal to a specific count, used for JIP
 *
 * Arguments:
 * 0: Language key name <STRING>
 * 1: Language display name <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["en", "English", 1] call acre_sys_core_fnc_addLanguageTypeJIP
 *
 * Public: No
 */

params ["_languageKey", "_languageName", "_count"];

[{count GVAR(languages) isEqualTo _count}, {
    _this call FUNC(addLanguageType);
}, [_languageKey, _languageName]] call CBA_fnc_waitUntilAndExecute;
