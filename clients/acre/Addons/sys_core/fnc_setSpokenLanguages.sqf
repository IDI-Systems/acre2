//fnc_setSpokenLanguages.sqf
#include "script_component.hpp"

private _list = _this;
private _languageIds = [];

{
	PUSH(_languageIds, ([_x] call FUNC(getLanguageId)));
} forEach _list;
ACRE_SPOKEN_LANGUAGES = _languageIds;
[_list select 0] call FUNC(setSpeakingLanguage);
ACRE_SPOKEN_LANGUAGES
