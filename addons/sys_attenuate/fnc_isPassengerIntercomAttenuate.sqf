/*
 * Author: ACRE2Team
 * Checks if the unit should be heard on the vehicle passenger intercom or not for the local player.
 *
 * Arguments:
 * 0: Unit to be evaluated <OBJECT>
 *
 * Return Value:
 * Is other unit speaking on intercom <Boolean>
 *
 * Example:
 * [unit] call acre_sys_attenuate_fnc_isPassengerIntercomAttenuate
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit"];
private _ret = false;

// Get the vehicle
private _vehicle = vehicle _unit;

if (_unit in ACRE_PLAYER_PASSENGER_INTERCOM) then {
    private _configIntercom = configFile >> "CfgVehicles" >> typeOf _vehicle;

    if (_hasPassengerIntercom == 1) then {
        _ret = true;
    };
};

_ret
