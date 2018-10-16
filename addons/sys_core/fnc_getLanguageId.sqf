#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the language index from a language Id.
 *
 * Arguments:
 * 0: Language Key <STRING>
 *
 * Return Value:
 * Language index <NUMBER>
 *
 * Example:
 * ["en"] call acre_sys_core_fnc_getLanguageId
 *
 * Public: No
 */

params ["_languageKey"];

private _ret = -1;
{
    _x params ["_language"];
    if (_language isEqualType _languageKey && {_language == _languageKey}) exitWith {
        _ret = _forEachIndex;
    };
} forEach GVAR(languages);

_ret
