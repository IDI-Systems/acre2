#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns an array of unique elements without nil values.
 *
 * Arguments:
 * 0: Array whose unique elements are extracted <ARRAY>
 *
 * Return Value:
 * Array of unique elements without nil values of the parsed array <ARRAY>
 *
 * Example:
 * [["ACRE_PRC343",nil,"ACRE_PRC148"]] call acre_sys_gui_fnc_uniqueArray
 *
 * Public: No
 */

params [["_inArray",[]]];

(_inArray arrayIntersect _inArray)
