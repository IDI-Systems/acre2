#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the current speaking language.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Language Index <NUMBER>
 *
 * Example:
 * [] call acre_sys_core_fnc_getSpeakingLanguageId
 *
 * Public: No
 */

private _ret = ACRE_CURRENT_LANGUAGE_ID;

if (GVAR(languages) isEqualTo []) then {
    _ret = 0;
};
_ret;
