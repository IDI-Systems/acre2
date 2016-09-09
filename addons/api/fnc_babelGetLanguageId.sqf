/*
 * Author: ACRE2Team
 * Gets the babel language key from the display name.
 *
 * Arguments:
 * 0: Language display name <STRING>
 *
 * Return Value:
 * Language key <STRING>
 *
 * Example:
 * ["English"] call acre_api_fnc_babelGetLanguageId;
 *
 * Public: Yes
 */

#include "script_component.hpp"

params ["_languageKey"];

[_languageKey] call EFUNC(sys_core,getLanguageId);
