/*
 * Author: ACRE2Team
 * Adds an actions for using vehicle intercom externally and passenger intercom.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_intercomActions
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];

private _type = typeOf _target;

// Configure if the vehicle has crew intercom.
if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasCrewIntercom") == 1) then {
    [_target] call FUNC(crewIntercomConfig);
};

// Exit if object has no passenger intercom
if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasPassengerIntercom") == 1) then {
    [_target] call FUNC(passengerIntercomAction);
};

// Exit if object has no infantry phone
if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasInfantryPhone") == 1) then {
    [_target] call FUNC(infantryPhoneAction);
};
