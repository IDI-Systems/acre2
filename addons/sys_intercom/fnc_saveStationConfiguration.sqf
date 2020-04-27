#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Saves the station configuration.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 * 2: Variable name of the vehicle seat the unit is in <STRING><OPTIONAL> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle acre_player, acre_player, INTERCOM_STATIONSTATUS_TURNEDOUTALLOWED] call acre_sys_intercom_fnc_saveStationConfiguration
 * [vehicle acre_player, acre_player, INTERCOM_STATIONSTATUS_CONNECTION, "acre_sys_intercom_station_driver"] call acre_sys_intercom_fnc_saveStationConfiguration
 *
 * Public: No
 */

params ["_vehicle", "_unit", ["_varName", ""]];

if ((_varName isEqualTo "") && {_varName = [_vehicle, _unit] call FUNC(getStationVariableName); _varName isEqualTo ""})  exitWith {
    ERROR_2("saveStationConfiguration: unit %1 not found in vehicle %2",_unit,_vehicle);
};

// Only make public if GUI is not opened
if (!GVAR(guiOpened) && {GVAR(configChanged)}) then {
    GVAR(configChanged) = false;
    private _intercom = _vehicle getVariable [_varName, []];
    _vehicle setVariable [_varName, _intercom, true];
};
