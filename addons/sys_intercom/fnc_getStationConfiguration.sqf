#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Gets the intercom connection status of the station the unit has access to.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 * 2: Intercom network <NUMBER>
 * 3: Intercom functionality to be retrieved <NUMBER>
 * 4: Variable name of the vehicle seat the unit is in <STRING><OPTIONAL> (default: "")
 *
 * Return Value:
 * Selected functionality state <VARIABLE>
 *
 * Example:
 * [vehicle acre_player, acre_player, 2, INTERCOM_STATIONSTATUS_CONNECTION] call acre_sys_intercom_fnc_getStationConfiguration
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_intercomNetwork", "_intercomFunctionality", ["_varName", ""]];

if (_varName isEqualTo "") then {
    _varName = [_vehicle, _unit] call FUNC(getStationVariableName);
};

if (_varName isEqualTo "") exitWith {
    ERROR_2("unit %1 not found in vehicle %2",_unit,_vehicle);
};

private _intercomArray = _vehicle getVariable [_varName, []];
private _intercomStatus = _intercomArray select _intercomNetwork;

(_intercomStatus select STATION_INTERCOM_CONFIGURATION_INDEX) select _intercomFunctionality
