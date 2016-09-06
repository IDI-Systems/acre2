/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */

 
#include "script_component.hpp"

private["_type", "_ret", "_i", "_scope", "_id", "_flag"];
params["_weapon"];

// check that it at least inherits from ACRE_BaseRadio *AND* has a unique ID
// If its scoped 1, that means its either a base or not a radio.
_flag = getNumber(configFile >> "CfgWeapons" >> _weapon >> "acre_isRadio");
_id = getNumber(configFile >> "CfgWeapons" >> _weapon >> "acre_uniqueId");
_scope = getNumber(configFile >> "CfgWeapons" >> _weapon >> "scope");
if(isNil "_flag" || isNil "_scope" || isNil "_id") exitWith { false };
if(_flag == 1 && _scope == 1) exitWith { true };

false
