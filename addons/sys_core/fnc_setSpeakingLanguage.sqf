/*
 * Author: ACRE2Team
 * Sets the local player speaking language by language key
 *
 * Arguments:
 * 0: Language key <STRING>
 *
 * Return Value:
 * Successful <BOOLEAN>
 *
 * Example:
 * ["en"] call acre_sys_core_fnc_setSpeakingLanguage
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_languageKey"];

private _ret = false;
{
    if ((_x select 0) == _languageKey) exitWith {
        ACRE_CURRENT_LANGUAGE_ID = _forEachIndex;
        _ret = true;
    };
} forEach GVAR(languages);

_ret;
