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
 * [cursorTarget] call acre_sys_intercom_iIntercomAction
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];

private _type = typeOf _target;

// Exit if object has no intercom
if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasPassengerIntercom") != 1 && getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasCrewIntercom") != 1) exitWith {};

// Exit if class already initialized
if (_type in GVAR(initializedIntercom)) exitWith {};
GVAR(initializedIntercom) pushBack _type;

// Passenger actions
private _intercomAction = [
    QGVAR(intercomAction),
    format ["%1", localize LSTRING(intercom)],
    ICON_RADIO_CALL,
    {true},
    {[_target, acre_player, CREW_INTERCOM] call FUNC(isIntercomAvailable) || [_target, acre_player, PASSENGER_INTERCOM] call FUNC(isIntercomAvailable)},
    {_this call FUNC(intercomChildrenActions)},
    [],
    [0, 0, 0],
    2,
    [false, true, false, false, false]
] call ace_interact_menu_fnc_createAction;
[_type, 1, ["ACE_SelfActions"], _intercomAction] call ace_interact_menu_fnc_addActionToClass;
