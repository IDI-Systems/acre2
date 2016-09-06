/*
 * Author: AUTHOR
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

private _list = _this;
private _languageIds = [];

{
    PUSH(_languageIds, ([_x] call FUNC(getLanguageId)));
} forEach _list;
ACRE_SPOKEN_LANGUAGES = _languageIds;
[_list select 0] call FUNC(setSpeakingLanguage);
ACRE_SPOKEN_LANGUAGES
