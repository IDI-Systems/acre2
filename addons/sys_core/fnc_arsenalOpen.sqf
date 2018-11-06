#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles open Arsenal.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_arsenalOpen
 *
 * Public: No
 */

if (is3DEN) exitWith {}; // Exit if Eden Arsenal

GVAR(arsenalOpen) = true;

private _weapons = [acre_player] call EFUNC(sys_core,getGear);

GVAR(arsenalRadios) = [];
ACRE_ARSENAL_RADIOS = [];
{
    private _radio = _x;
    private _baseClass = [_radio] call EFUNC(sys_radio,getRadioBaseClassname);
    [acre_player, _radio, _baseClass] call EFUNC(sys_core,replaceGear);
    GVAR(arsenalRadios) pushBack [_baseClass,_radio];
    ACRE_ARSENAL_RADIOS pushBack _radio;
} forEach (_weapons select {_x call EFUNC(sys_radio,isUniqueRadio)});
