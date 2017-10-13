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
 * [unit] call acre_sys_attenuate_fnc_isIntercomAttenuate
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

    // Return false if the unit is not using the infantry phone
    if (isNull _vehicleInfantryPhone) exitWith {false};

    // Unit is using the infantry phone
    _vehicle = _vehicleInfantryPhone;
};

{
    if (_unit in _x) then {
        _ret = true;
    };
    if (_ret) exitWith {};
} forEach ACRE_PLAYER_INTERCOM;

_ret
