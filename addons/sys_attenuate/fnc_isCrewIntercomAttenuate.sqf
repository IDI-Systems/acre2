/*
 * Author: ACRE2Team
 * Checks if the unit should be heard on vehicle intercom or not for the local player.
 *
 * Arguments:
 * 0: Unit to be evaluated <OBJECT>
 *
 * Return Value:
 * Is other unit speaking on intercom <Boolean>
 *
 * Example:
 * [unit] call acre_sys_attenuate_fnc_isCrewIntercomAttenuate
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
    private _vehicleInfantryPhone = _unit getVariable [QEGVAR(sys_intercom,vehicleInfantryPhone), objNull];
    if (!isNull _vehicleInfantryPhone) then {
        _vehicle = _vehicleInfantryPhone;
    };
};

if (_unit in ACRE_PLAYER_VEHICLE_CREW) then {
    private _configIntercom = configFile >> "CfgVehicles" >> typeOf _vehicle;
    private _hasIntercom = getNumber (_configIntercom >> "acre_hasIntercom");
    // Backwards compatibility @todo remove in 2.7.0
    if (isNumber (_configIntercom >> "ACRE" >> "CVC" >> "hasCVC")) then {
        _hasIntercom = getNumber (_configIntercom >> "ACRE" >> "CVC" >> "hasCVC");
    };
    if (_hasIntercom == 1) then {
        _ret = true;
    };
};

_ret
