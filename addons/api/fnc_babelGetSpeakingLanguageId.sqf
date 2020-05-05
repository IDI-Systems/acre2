#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the ID of the language which is actively being spoken (set with babelSetSpeakingLanguage).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Language ID <STRING>
 *
 * Example:
 * [] call acre_api_fnc_babelGetSpeakingLanguageId;
 *
 * Public: Yes
 */

[] call EFUNC(sys_core,getSpeakingLanguageId);
