/*
 * Author: ACRE2Team
 * Gets the ID of the language which is actively being spoken (set with babelSetSpeakingLanguage)
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Language key <STRING>
 *
 * Example:
 * [] call acre_api_fnc_babelSetSpeakingLanguageId;
 *
 * Public: Yes
 */
#include "script_component.hpp"

[] call EFUNC(sys_core,getSpeakingLanguageId);
