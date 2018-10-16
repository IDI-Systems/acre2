#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns a list of language ids understood by the local player.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Array of language Ids <Array>
 *
 * Example:
 * [] call acre_sys_core_fnc_getSpokenLanguages
 *
 * Public: No
 */

ACRE_SPOKEN_LANGUAGES apply {(GVAR(languages) select _x) select 0};
