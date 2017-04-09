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

// Exit if object has no passenger intercom phone
if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasPassengerIntercom") != 1) exitWith {};

// Exit if class already initialized
if (_type in GVAR(initializedPassengerIntercom)) exitWith {};
GVAR(initializedPassengerIntercom) pushBack _type;

// Passenger actions
private _passengerIntercomAction = [
    QGVAR(passengerIntercom),
    format ["%1 %2", localize LSTRING(passenger), localize LSTRING(intercom)],
    ICON_RADIO_CALL,
    {true},
    {[_target, acre_player, PASSENGER_INTERCOM] call FUNC(isIntercomAvailable)},
    {_this call FUNC(passengerIntercomChildrenActions)},
    [],
    [0, 0, 0],
    2,
    [false, true, false, false, false]
] call ace_interact_menu_fnc_createAction;
[_type, 1, ["ACE_SelfActions"], _passengerIntercomAction] call ace_interact_menu_fnc_addActionToClass;
