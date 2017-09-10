/*
 * Author: ACRE2Team
 * Configures the initial intercom connectivity (not connected, connected to crew intercom, connected to pax intercom or connected to both) for all allowed seats. *
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player] call acre_sys_intercom_fnc_configIntercomStatus
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _type = typeOf _vehicle;

private _intercomStatus = [];
private _intercomPos = [];

// Get intercom positions
if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasCrewIntercom") == 1) then {
    _intercomPos = +(_vehicle getVariable [QGVAR(crewIntercomPositions), []]);
};

if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasPassengerIntercom") == 1) then {
    if (count _intercomPos > 0) then {
        {
            _intercomPos pushBackUnique _x;
        } forEach (_vehicle getVariable [QGVAR(passengerIntercomPositions), []]);
    } else {
        _intercomPos = +(_vehicle getVariable [QGVAR(passengerIntercomPositions), []]);
    };
};

{
    _intercomStatus pushBackUnique [_x, NO_INTERCOM, INTERCOM_DEFAULT_VOLUME];
} forEach _intercomPos;

_vehicle setVariable [QGVAR(intercomStatus), _intercomStatus, true];
