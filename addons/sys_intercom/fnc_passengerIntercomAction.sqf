/*
 * Author: ACRE2Team
 * Adds an action for joining the passenger intercom.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_passengerIntercomAction
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];

private _type = typeOf _target;

// Exit if object has no infantry phone
if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasPassengerIntercom") != 1) exitWith {};

private _availableConnections = getNumber (configFile >> "CfgVehicles" >> _type >> "acre_passengerIntercomConnections");

// Set the number of passenger intercom connections
_target setVariable [QGVAR(availablePassIntercomConn), _availableConnections, true];

// Passenger actions
private _passengerIntercomAction = [
    QGVAR(passengerIntercom),
    localize LSTRING(passengerIntercom),
    ICON_RADIO_CALL,
    {true},
    {true},
    {_this call FUNC(passengerIntercomChildrenActions)},
    [],
    [0, 0, 0],
    2,
    [false, true, false, false, false]
] call ace_interact_menu_fnc_createAction;
[_type, 1, ["ACE_SelfActions"], _passengerIntercomAction] call ace_interact_menu_fnc_addActionToClass;
