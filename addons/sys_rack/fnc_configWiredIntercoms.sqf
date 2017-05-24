/*
 * Author: ACRE2Team
 * Configures rack intercom network availability.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Rack class <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_configWiredIntercoms
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_rack"];

private _type = typeOf _vehicle;

private _accessibleIntercoms = getArray (_rack >> "intercom");
private _hasCrewIntercom = getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasCrewIntercom");
private _hasPassengerIntercom = getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasPassengerIntercom");

// Set by default to have access to all intercom networks if none was specified
if (count _accessibleIntercoms ==  0) then {
    if (_hasCrewIntercom == 1) then {
        _accessibleIntercoms = ["crew"];
    };

    if ((_hasPassengerIntercom == 1) && count (_vehicle getVariable [QEGVAR(sys_intercom,passengerIntercomPositions), []]) > 0) then {
        _accessibleIntercoms pushBack "passenger";
    };
} else {
    _accessibleIntercoms = _accessibleIntercoms apply {toLower _x};
    // Check for a valid configuration
    if ("crew" in _accessibleIntercoms && (_hasCrewIntercom != 1)) then {
        WARNING_1("Vehicle type %1 does not have a crew intercom but the rack %2 can have access to its network",_type,_rack);
        _accessibleIntercoms = _accessibleIntercoms - ["crew"];
    };

    if ("passenger" in _accessibleIntercoms && ((_hasPassengerIntercom != 1) || count (_vehicle getVariable [QEGVAR(sys_intercom,passengerIntercomPositions), []]) == 0)) then {
        if (_hasPassengerIntercom != 1) then {
            WARNING_1("Vehicle type %1 does not have a passenger intercom but the rack %2 can have access to its network",_type,_rack);
        } else {
            WARNING_1("Vehicle type %1 does not have a valid passenger intercom configuration. Disabling access of rack %2 to passenger intercom",_type);
        };
        _accessibleIntercoms = _accessibleIntercoms - ["passenger"];
    };
};

_accessibleIntercoms
