/*
 * Author: ACRE2Team
 * Adds actions for using vehicle intercom externally and passenger intercom.
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

// Configure if the vehicle has crew intercom
private _hasCrewIntercom = getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasCrewIntercom") == 1;
if (_hasCrewIntercom) then {
    [_target] call FUNC(crewIntercomConfig);
    if (hasInterface && (isClass (configFile >> "CfgPatches" >> "ace_interact_menu"))) then {
        [_target] call FUNC(intercomAction);
    };
};

// Exit if object has no passenger intercom
private _hasPassengerIntercom = getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasPassengerIntercom") == 1;
if (_hasPassengerIntercom) then {
    [_target] call FUNC(passengerIntercomConfig);
    if (hasInterface && (isClass (configFile >> "CfgPatches" >> "ace_interact_menu"))) then {
        [_target] call FUNC(intercomAction);
    };
};

if (_hasCrewIntercom || _hasPassengerIntercom) then {
    [_target] call FUNC(configIntercomStatus);
};

// Exit if object has no infantry phone
if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasInfantryPhone") == 1) then {
    [_target] call FUNC(infantryPhoneConfig);
    if (hasInterface) then {
        [_target] call FUNC(infantryPhoneAction);
    };
};
