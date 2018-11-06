#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the intercom connection status of the vehicle seat the unit is in.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 * 2: Intercom network <NUMBER>
 * 5: Variable name of the vehicle seat the unit is in <STRING><OPTIONAL> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle acre_player, acre_player, 1] call acre_sys_intercom_fnc_setStationUnit
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_intercomNetwork", ["_varName", ""]];

if (_varName isEqualTo "") then {
    _varName = [_vehicle, _unit] call FUNC(getStationVariableName);
};

if (_varName isEqualTo "") exitWith {
    ERROR_2("unit %1 not found in vehicle %2",_unit,_vehicle);
};

private _intercomArray = _vehicle getVariable [_varName, []];
private _intercomStatus = _intercomArray select _intercomNetwork;

_intercomStatus set [STATION_INTERCOM_UNIT_INDEX, _unit];
_vehicle setVariable [_varName, _intercomArray, true];
