/*
 * Author: ACRE2Team
 * Checks if the unit should be heard on vehicle intercom or not for the local player.
 *
 * Arguments:
 * 0: unit to be evaluated <OBJECT>
 *
 * Return Value:
 * is other unit speaking on intercom <Boolean>
 *
 * Example:
 * [unit] call acre_sys_attenuate_fnc_isCrewIntercomAttenuate
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];
private _ret = false;

if ((_unit in ACRE_PLAYER_VEHICLE_CREW) and {vehicle acre_player != acre_player}) then {
    _hasCVC = getNumber (configFile >> "CfgVehicles" >> typeOf (vehicle acre_player) >> "ACRE" >> "CVC" >> "hasCVC");
    if (_hasCVC == 1) then {
        _ret = true;
    };
};

_ret
