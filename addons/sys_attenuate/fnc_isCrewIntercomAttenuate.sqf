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
    private _vehicleInfantryPhone = _unit getVariable [QEGVAR(sys_core,vehicleInfantryPhone), objNull];
    if (!isNull _vehicleInfantryPhone) then {
        _vehicle = _vehicleInfantryPhone;
    };
};

if (_unit in ACRE_PLAYER_VEHICLE_CREW) then {
    private _hasCVC = getNumber (configFile >> "CfgVehicles" >> typeOf (_vehicle) >> "ACRE" >> "CVC" >> "hasCVC");
    if (_hasCVC == 1) then {
        _ret = true;
    };
};

_ret
