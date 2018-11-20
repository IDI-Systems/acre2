#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles entering a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit entering a vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player] call acre_sys_intercom_fnc_enterVehicle
 *
 * Public: No
 */

params ["_vehicle", "_unit"];

if (_unit != _vehicle) then {
    // Save current seat variable
    private _varName = [_vehicle, _unit] call FUNC(getStationVariableName);

    // Save vehicle
    _unit setVariable [QGVAR(intercomVehicle), _vehicle];

    // Save current seat variable
    private _varName = [_vehicle, _unit] call FUNC(getStationVariableName);
    _unit setVariable [QGVAR(role), _varName];

    [_vehicle, _unit] call FUNC(seatSwitched);

    // Start PFH
    GVAR(intercomPFH) = [DFUNC(intercomPFH), 1.1, [_unit, _vehicle]] call CBA_fnc_addPerFrameHandler;
} else {
    [GVAR(intercomPFH)] call CBA_fnc_removePerFrameHandler;

    _vehicle = _unit getVariable [QGVAR(intercomVehicle), objNull];
    // Handle the case of broadcasting or using a seat that uses limited connections

    [_vehicle, _unit] call FUNC(seatSwitched);

    // Reset variables
    _unit setVariable [QGVAR(intercomVehicle), objNull];
    _unit setVariable [QGVAR(role), ""];
    ACRE_PLAYER_INTERCOM = [];
};
