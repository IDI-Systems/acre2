/*
 * Author: ACRE2Team
 * Handles closing Arsenal.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_arsenalClose
 *
 * Public: No
 */
#include "script_component.hpp"

if (is3DEN) exitWith {}; // Exit if Eden Arsenal

private _weapons = [acre_player] call EFUNC(sys_core,getGear);

{
    _x params ["_baseClass","_radio"];
    private _idx = _weapons find (toLower _baseClass);
    if (_idx != -1) then {
        [acre_player, _baseClass, _radio] call EFUNC(sys_core,replaceGear);
        _weapons deleteAt _idx;
    }
} forEach GVAR(arsenalRadios);

ACRE_ARSENAL_RADIOS = [];
GVAR(arsenalRadios) = [];
GVAR(arsenalOpen) = false;
