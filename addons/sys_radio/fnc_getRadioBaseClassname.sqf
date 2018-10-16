#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns whether the baseclass name for a given radio classname.
 *
 * Arguments:
 * 0: Classname <STRING>
 *
 * Return Value:
 * Is Unique <BOOL>
 *
 * Example:
 * ["acre_prc152_id_1"] call acre_sys_radio_fnc_getRadioBaseClassname
 *
 * Public: No
 */

params ["_radio"];

if (HASH_HASKEY(GVAR(radioBaseClassCache),_radio)) exitWith {
    HASH_GET(GVAR(radioBaseClassCache),_radio);
};

private _baseClassRadio = getText (configFile >> "CfgWeapons" >> _radio >> "acre_baseClass");

if (_baseClassRadio == "") then { _baseClassRadio = _radio; };
HASH_SET(GVAR(radioBaseClassCache),_radio,_baseClassRadio);

_baseClassRadio
