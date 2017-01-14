/*
 * Author: ACRE2Team
 * Sets the spoken languages of the local player.
 *
 * Arguments:
 * 0: Languages by Id <ARRAY>
 *
 * Return Value:
 * Spoken Languages <ARRAY>
 *
 * Example:
 * ["en"] call acre_sys_core_fnc_setSpokenLanguages
 *
 * Public: No
 */
#include "script_component.hpp"

private _list = _this;
private _languageIds = [];

{
    _languageIds pushBack ([_x] call FUNC(getLanguageId));
} forEach _list;
ACRE_SPOKEN_LANGUAGES = _languageIds;
[_list select 0] call FUNC(setSpeakingLanguage);
ACRE_SPOKEN_LANGUAGES
