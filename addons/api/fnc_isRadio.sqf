/*
 * Author: ACRE2Team
 * Returns true or false whether the provided weapon is a ACRE radio or not.
 *
 * Arguments:
 * 0: Classname <STRING>
 *
 * Return Value:
 * Whether the provided object class name is a radio or not <BOOLEAN>
 *
 * Example:
 * _isRadio = ["NVGoggles"] call acre_api_fnc_isRadio;
 *
 * Public: Yes
 */
#include "script_component.hpp"

params["_weapon"];

// check that it at least inherits from ACRE_BaseRadio *AND* has a unique ID
// If its scoped 1, that means its either a base or not a radio.
private _flag = getNumber(configFile >> "CfgWeapons" >> _weapon >> "acre_isRadio");
private _id = getNumber(configFile >> "CfgWeapons" >> _weapon >> "acre_uniqueId");
private _scope = getNumber(configFile >> "CfgWeapons" >> _weapon >> "scope");
if(isNil "_flag" || isNil "_scope" || isNil "_id") exitWith { false };
if(_flag == 1 && _scope == 1) exitWith { true };

false
