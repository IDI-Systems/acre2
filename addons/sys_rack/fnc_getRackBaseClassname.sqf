#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns whether the baseclass name for a given rack classname.
 *
 * Arguments:
 * 0: Classname <STRING>
 *
 * Return Value:
 * Is Unique <BOOL>
 *
 * Example:
 * ["acre_vrc111_id_1"] call acre_sys_rack_fnc_getRackBaseClassname
 *
 * Public: No
 */

params ["_rack"];

if (HASH_HASKEY(GVAR(rackBaseClassCache),_rack)) exitWith {
    HASH_GET(GVAR(rackBaseClassCache),_rack);
};

private _baseClassRack = getText (configFile >> "CfgVehicles" >> _rack >> "acre_baseClass");

if (_baseClassRack == "") then { _baseClassRack = _rack; };
HASH_SET(GVAR(rackBaseClassCache),_rack,_baseClassRack);

_baseClassRack
