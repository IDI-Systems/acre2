#include "script_component.hpp"
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

params ["_radioId"];

if (HASH_HASKEY(GVAR(radioUniqueCache),_radioId)) exitWith {
    HASH_GET(GVAR(radioUniqueCache),_radioId);
};

private _isUnique = getNumber (configFile >> "CfgWeapons" >> _radioId >> "acre_isUnique") == 1;
HASH_SET(GVAR(radioUniqueCache),_radioId,_isUnique);

_isUnique
