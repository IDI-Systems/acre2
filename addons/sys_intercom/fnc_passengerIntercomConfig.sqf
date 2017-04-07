/*
 * Author: ACRE2Team
 * Configures the seats where the passenger intercom is available as well as the number of connections.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_passengerIntercomConfig
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _type = typeOf _vehicle;

// All crew members have access to passenger intercom
private _availablePassIntercomPos = +(_vehicle getVariable [QGVAR(crewIntercomPositions), []]);
private _passengerIntercomPositions = getArray (configFile >> "CfgVehicles" >> _type >> "acre_passengerIntercomPositions");
private _default = false;
if (count _passengerIntercomPositions == 0 || "default" in _passengerIntercomPositions) then {
    _default = true;
    if (count _passengerIntercomPositions > 1) then {
        WARNING_1("Vehicle type %1 has the default entry followed by other options. This is not supported. Ignoring custom configuration for passenger intercom.",_type);
        _default = true;
    };
};

if (_default) then {
    // Add all cargo positions
    private _cargoPositions = fullCrew [_vehicle, "cargo", true];
    {
        _availablePassIntercomPos pushBackUnique ["cargo", _x select 2];
    } forEach _cargoPositions;
} else {
    private _temp = [_vehicle, _passengerIntercomPositions] call EFUNC(sys_core,processConfigArray);
    {
        _availablePassIntercomPos pushBackUnique _x;
    } forEach _temp;
};

// Remove all exceptions
private _passengerIntercomExceptions = getArray (configFile >> "CfgVehicles" >> _type >> "acre_passengerIntercomExceptions");
private _temp = [_vehicle, _passengerIntercomExceptions] call EFUNC(sys_core,processConfigArray);
private _exceptionsPassIntercomPos = [];
{
    if (_x in _availablePassIntercomPos) then {
        _availablePassIntercomPos = _availablePassIntercomPos - [_x]
    } else {
        // This could be a FFV turret
        _exceptionsPassIntercomPos pushBackUnique _x;
    };
} forEach _temp;

// Add the ones without crew intercom to the list of exceptions as well.
{
    if (_x in _availablePassIntercomPos) then {
        _availablePassIntercomPos = _availablePassIntercomPos - [_x];
    } else {
        _exceptionsPassIntercomPos pushBackUnique _x
    };
} forEach (_vehicle getVariable [QGVAR(crewIntercomExceptions), []]);

private _availableConnections = getNumber (configFile >> "CfgVehicles" >> _type >> "acre_passengerIntercomConnections");
if (_availableConnections == -1) then {
    _availableConnections = count _availablePassIntercomPos;
};

if (_availableConnections == 0) then {
    WARNING_1("Vehicle type %1 has passenger intercom enabled but no available connections. Setting it to the number of available positions",_type);
    _availableConnections = count _availablePassIntercomPos;
};

if (_availablePassIntercomPos isEqualTo (_vehicle getVariable [QGVAR(crewIntercomPositions), []]) && _exceptionsPassIntercomPos isEqualTo (_vehicle getVariable [QGVAR(crewIntercomExceptions), []])) then {
    WARNING_3("Vehicle type %1 has the same positions defined for crew and passenger intercoms. Disabling passenger intercom. (Positions: %2 Esceptions: %3)",_type,_availablePassIntercomPos,_exceptionsPassIntercomPos);
    _availablePassIntercomPos = [];
    _exceptionsPassIntercomPos = [];
    _availableConnections = 0;
};

_vehicle setVariable [QGVAR(passengerIntercomPositions), _availablePassIntercomPos];
_vehicle setVariable [QGVAR(passengerIntercomExceptions), _exceptionsPassIntercomPos];
_vehicle setVariable [QGVAR(availablePassIntercomConn), _availableConnections];
