/*
 * Author: ACRE2Team
 * Sets the language the player will speak in.
 *
 * Arguments:
 * 0: Language ID <STRING>
 *
 * Return Value:
 * Setup successful <BOOL>
 *
 * Example:
 * ["en"] call acre_api_fnc_babelSetSpeakingLanguage;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [
    ["_languageKey", "", [""]]
];

if (_languageKey isEqualTo "") exitWith {false};

[_languageKey] call EFUNC(sys_core,setSpeakingLanguage);
