/*
 * Author: ACRE2Team
 * Sets the languages that the local player can speak.
 *
 * Arguments:
 * N: Language keys as strings <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["en"] call acre_api_fnc_babelSetSpokenLanguages;
 *
 * Public: Yes
 */
#include "script_component.hpp"

private _list = _this;

_list call EFUNC(sys_core,setSpokenLanguages);
