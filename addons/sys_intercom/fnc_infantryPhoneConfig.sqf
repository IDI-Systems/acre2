/*
 * Author: ACRE2Team
 * Configures infantry phone intercom network availability.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_infantryPhoneConfig
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _type = typeOf _vehicle;

// Configure what intercom networks the infantry phone has access to
private _infantryPhoneIntercom = getArray (configFile >> "CfgVehicles" >> _type >> "acre_infantryPhoneIntercom");
private _hasCrewIntercom = getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasCrewIntercom");
private _hasPassengerIntercom = getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasPassengerIntercom");

// Set by default to have access to all intercom networks if none was specified
if (count _infantryPhoneIntercom ==  0) then {
    if (_hasCrewIntercom == 1) then {
        _infantryPhoneIntercom = ["crew"];
    };

    if ((_hasPassengerIntercom == 1) && count (_vehicle getVariable [QGVAR(crewIntercomPositions), []]) > 0) then {
        _infantryPhoneIntercom pushBack "passenger";
    };
} else {
    // Check for a valid configuration
    if ("crew" in _infantryPhoneIntercom && (_hasCrewIntercom != 1)) then {
        WARNING_1("Vehicle type %1 does not have a crew intercom but the infantry phone can have access to its network",_type);
        _infantryPhoneIntercom = _infantryPhoneIntercom - ["crew"];
    };

    if ("passenger" in _infantryPhoneIntercom && ((_hasPassengerIntercom != 1) || count (_vehicle getVariable [QGVAR(crewIntercomPositions), []]) > 0)) then {
        if (_hasPassengerIntercom != 1) then {
            WARNING_1("Vehicle type %1 does not have a passenger intercom but the infantry phone can have access to its network",_type);
        } else {
            WARNING_1("Vehicle type %1 does not have a valid passenger intercom configuration. Disabling infantry phone for passenger intercom",_type);
        };
        _infantryPhoneIntercom = _infantryPhoneIntercom - ["passenger"];
    };
};

_vehicle setVariable [QGVAR(infantryPhoneIntercom), _infantryPhoneIntercom, true];

// Hook for third party mods with actions when picking returning infantry phone
private _eventInfantryPhone = getText (configFile >> "CfgVehicles" >> _type >> "acre_eventInfantryPhone");
if (_eventInfantryPhone != "") then {
    _vehicle setVariable [QGVAR(eventInfantryPhone), _eventInfantryPhone, true];
};
