#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the languages that the local player can speak.
 *
 * Arguments:
 * N: Language IDs <ARRAY>
 *
 * Return Value:
 * Setup successful <BOOL>
 *
 * Example:
 * ["en"] call acre_api_fnc_babelSetSpokenLanguages;
 *
 * Public: Yes
 */

private _list = _this;

_list call EFUNC(sys_core,setSpokenLanguages);
