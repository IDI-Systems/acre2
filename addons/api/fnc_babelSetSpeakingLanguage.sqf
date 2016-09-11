/*
 * Author: ACRE2Team
 * Sets the language the player will speak in.
 *
 * Arguments:
 * 0: Language key <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["en"] call acre_api_fnc_babelSetSpeakingLanguage;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_languageKey"];

[_languageKey] call EFUNC(sys_core,setSpeakingLanguage);
