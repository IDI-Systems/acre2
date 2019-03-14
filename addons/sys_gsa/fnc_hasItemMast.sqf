#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if unit has the mast item.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unique Radio ID <STRING>
 *
 * Return Value:
 * Compatible <BOOL>
 *
 * Example:
 * [cursorTarget, "acre_prc152_id_1"] call acre_sys_gsa_fnc_hasItemMast
 *
 * Public: No
 */

params ["_unit"];

private _hasItemMast = false;

{
    if (_x isEqualTo "ACRE_VHF30108MAST") exitWith {
        _hasItemMast = true;
    };
} forEach (items _unit);

_hasItemMast
