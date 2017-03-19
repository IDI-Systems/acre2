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

// The player is not inside a vehicle. Check if it is using the intercom network externally
if (_vehicle == _unit) then {
    private _vehicleInfantryPhone = _unit getVariable [QEGVAR(sys_intercom,vehicleInfantryPhone), [objNull, objNull]] select 0;
    if (!isNull _vehicleInfantryPhone) then {
        _vehicle = _vehicleInfantryPhone;
    };
};

if (_unit in ACRE_PLAYER_PASSENGER_INTERCOM) then {
    private _configIntercom = configFile >> "CfgVehicles" >> typeOf _vehicle;
    private _hasPassengerIntercom = getNumber (_configIntercom >> "acre_hasPassengerIntercom");

    if (_hasPassengerIntercom == 1) then {
        _ret = true;
    };
};

_ret
