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
#include "script_component.hpp"

params["_weapon"];

// check that it at least inherits from ACRE_BaseRadio *AND* has a unique ID
// If its scoped 1, that means its either a base or not a radio.
private _flag = getNumber(configFile >> "CfgWeapons" >> _weapon >> "acre_isRadio");
private _scope = getNumber(configFile >> "CfgWeapons" >> _weapon >> "scope");
if(isNil "_flag" || isNil "_scope") exitWith { false };
if(_flag == 1 && _scope == 2) exitWith { true };

false
