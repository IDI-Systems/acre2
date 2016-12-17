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

private _radioList = [];

if (!ACRE_IS_SPECTATOR) then {
    private _weapons = [acre_player] call EFUNC(lib,getGear);
    {
        if (getNumber (configFile >> "CfgWeapons" >> _x >> "acre_isUnique") == 1) then {
            _radioList pushBackUnique _x;
        };
    } forEach _weapons;
    
    //Auxilary radios are for radios not in inventory like racked radios.
    {
        _radioList pushBackUnique _x;
    } forEach ACRE_ACTIVE_RACK_RADIOS;
    
    if (ACRE_ACTIVE_RADIO != "") then {
        _radioList pushBackUnique ACRE_ACTIVE_RADIO;
    };
} else {
    _radioList = ACRE_SPECTATOR_RADIOS;
};

_radioList
