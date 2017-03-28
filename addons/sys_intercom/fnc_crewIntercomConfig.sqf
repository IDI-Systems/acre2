/*
 * Author: ACRE2Team
 * Configures the seats where the crew intercom is available.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_crewIntercomConfig
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _type = typeOf _vehicle;

if (getNumber (configFile >> "CfgVehicles" >> _type >> "acre_hasCrewIntercom") != 1) exitWith {};

private _crewIntercomPositions = getArray (configFile >> "CfgVehicles" >> _type >> "acre_crewIntercomPositions");
private _availableCrewIntercomPos = [];

private _default = false;
if (count _crewIntercomPositions == 0 || "default" in _crewIntercomPositions) then {
    _default = true;
    if (count _crewIntercomPositions > 1) then {
        WARNING_1("Vehicle type %1 has the default entry followed by other options. This is not supported. Ignoring custom configuration for crew intercom.",_type);
        _default = true;
    };
};

if (_default) then {
    // Use Standard configuration
    // Driver, commander and gunner positions. Only select thoses that are defined.
    {
        private _role = _x;
        private _crew = fullCrew [_vehicle, _role, true];
        {
            if (_role == toLower (_x select 1)) then {
                _availableCrewIntercomPos pushBackUnique [_role];
            };
        } forEach _crew;
    } forEach ["driver", "commander", "gunner"];

    // Turrets excluding FFV turrets
    {
        _availableCrewIntercomPos pushBackUnique ["turret", _x];
    } forEach allTurrets [_vehicle, false];
} else {
    _availableCrewIntercomPos = [_vehicle, _crewIntercomPositions] call FUNC(processConfigArray);
};

// Remove all exceptions
private _crewIntercomExceptions = getArray (configFile >> "CfgVehicles" >> _type >> "acre_crewIntercomExceptions");
private _temp = [_vehicle, _crewIntercomExceptions] call FUNC(processConfigArray);
private _exceptionsCrewIntercomPos = [];
{
    if (_x in _availableCrewIntercomPos) then {
        _availableCrewIntercomPos = _availableCrewIntercomPos - [_x];
    } else {
        // This could be a FFV turret
        _exceptionsCrewIntercomPos pushBackUnique _x;
    };
} forEach _temp;

_vehicle setVariable [QGVAR(crewIntercomPositions), _availableCrewIntercomPos];
_vehicle setVariable [QGVAR(crewIntercomExceptions), _exceptionsCrewIntercomPos];
