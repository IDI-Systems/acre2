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

if (alive acre_player) then {
    private _weapons = [acre_player] call EFUNC(sys_core,getGear);
    {
        if (getNumber (configFile >> "CfgWeapons" >> _x >> "acre_isUnique") == 1) then {
            _radioList pushBack _x;
        };
    } forEach _weapons;
    if (ACRE_ACTIVE_RADIO != "") then {
        _radioList pushBackUnique ACRE_ACTIVE_RADIO;
    };
} else {
    _radioList = ACRE_SPECTATOR_RADIOS;
};

_radioList
