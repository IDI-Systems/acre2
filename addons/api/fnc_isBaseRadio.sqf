#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if a class name is a base radio or not. Base radios are ACRE radios without IDs. e.g. “ACRE_PRC148” would return true, “ACRE_PRC148_ID_1” would return false
 *
 * Arguments:
 * 0: Item name <STRING>
 *
 * Return Value:
 * Is base radio <BOOLEAN>
 *
 * Example:
 * _result = ["ACRE_PRC343"] call acre_api_fnc_isBaseRadio;
 *
 * Public: Yes
 */

params [
    ["_weapon", "", [""]]
];

_weapon call EFUNC(sys_radio,isBaseClassRadio);
