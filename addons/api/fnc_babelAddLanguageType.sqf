/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

// Babel is not maintained on non-clients.
if (!hasInterface) exitWith {};

params ["_languageKey", "_languageName"];

[_languageKey, _languageName] call EFUNC(sys_core,addLanguageType);
