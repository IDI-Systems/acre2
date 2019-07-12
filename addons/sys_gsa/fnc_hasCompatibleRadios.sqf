#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Checks if a unit has compatible radios with a GSA.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Ground Spike Antenna <OBJECT>
 *
 * Return Value:
 * True if a unit has compatible radios with a GSA, false otherwise <BOOL>
 *
 * Example:
 * [acre_player, cursorTarget] call acre_sys_gsa_fnc_hasCompatibleRadios
 *
 * Public: No
 */

 params [["_unit", objNull], ["_gsa", objNull]];

if (isNull _unit || {isNull _gsa}) exitWith {
    false
};

private _radioList = [] call EFUNC(sys_data,getPlayerRadioList);
private _hasCompatible = false;
{
    if ([_gsa, _x] call FUNC(isRadioCompatible)) exitWith {
        _hasCompatible = true;
    };
} forEach _radioList;

_hasCompatible
