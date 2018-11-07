#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the local player speaking language by language key.
 *
 * Arguments:
 * 0: Language key <STRING>
 *
 * Return Value:
 * Successful <BOOL>
 *
 * Example:
 * ["en"] call acre_sys_core_fnc_setSpeakingLanguage
 *
 * Public: No
 */

params ["_languageKey"];

private _ret = false;
{
    _x params ["_language"];
    if (_language isEqualType _languageKey && {_language == _languageKey}) exitWith {
        ACRE_CURRENT_LANGUAGE_ID = _forEachIndex;
        _ret = true;
    };
} forEach GVAR(languages);

_ret;
