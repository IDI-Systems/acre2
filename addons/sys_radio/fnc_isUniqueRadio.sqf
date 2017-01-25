/*
 * Author: ACRE2Team
 * Returns whether a classname has the property acre_isUnique. This function exists because it is used frequently and config lookup is expensive.
 *
 * Arguments:
 * 0: Classname <STRING>
 *
 * Return Value:
 * Is Unique <BOOL>
 *
 * Example:
 * ["acre_prc152_id_1"] call acre_sys_radio_fnc_isUniqueRadio
 *
 * Public: No
 */
#include "script_component.hpp"

private _isUnique = false;

if (HASH_HASKEY(GVAR(radioUniqueCache),_this)) then {
    _isUnique = HASH_GET(GVAR(radioUniqueCache),_this);
} else {
    _isUnique = getNumber(configFile >> "CfgWeapons" >> _this >> "acre_isUnique") == 1;
    HASH_SET(GVAR(radioUniqueCache),_this,_isUnique);
};

_isUnique;
