#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Get the language display name from the language key.
 *
 * Arguments:
 * 0: Language key <STRING>
 *
 * Return Value:
 * Language display name ("" if not found) <STRING>
 *
 * Example:
 * ["en"] call acre_sys_core_fnc_getLanguageName
 *
 * Public: No
 */

params ["_languageKey"];

private _ret = "";
if (IS_NUMBER(_languageKey)) then {
    _ret = (GVAR(languages) select _languageKey) select 1;
} else {
    {
        if ((_x select 0) == _languageKey) exitWith {
            _ret = _x select 1;
        };
    } forEach GVAR(languages);
};
_ret
