#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Sets the intercom connection status of the vehicle seat the unit is in.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 * 2: Intercom network <NUMBER>
 * 3: Intercom functionality <NUMBER>
 * 4: New value <VARIALBE TYPE>
 * 5: Variable name of the vehicle seat the unit is in <STRING><OPTIONAL> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle acre_player, acre_player, INTERCOM_STATIONSTATUS_TURNEDOUTALLOWED, false] call acre_sys_intercom_fnc_setStationConfiguration
 * [vehicle acre_player, acre_player, INTERCOM_STATIONSTATUS_CONNECTION, 1, "acre_sys_intercom_station_driver"] call acre_sys_intercom_fnc_setStationConfiguration
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_intercomNetwork", "_intercomFunctionality", "_value", ["_varName", ""]];

if (_varName isEqualTo "") then {
    _varName = [_vehicle, _unit] call FUNC(getStationVariableName);
};

if (_varName isEqualTo "") exitWith {
    ERROR_2("unit %1 not found in vehicle %2",_unit,_vehicle);
};

private _intercomArray = _vehicle getVariable [_varName, []];
private _intercomStatus = _intercomArray select _intercomNetwork;
private _oldValue = (_intercomStatus select STATION_INTERCOM_CONFIGURATION_INDEX) select _intercomFunctionality;

if (_oldValue isEqualTo _value) exitWith {
    //DEBUG_1("Set the same value for intercom functionality %1",_intercomFunctionality);
};

private _changed = false;
switch (_intercomFunctionality) do {
    case INTERCOM_STATIONSTATUS_HASINTERCOMACCESS: { _changed = true };
    case INTERCOM_STATIONSTATUS_CONNECTION: {
        if !((_intercomStatus select STATION_INTERCOM_CONFIGURATION_INDEX) select INTERCOM_STATIONSTATUS_FORCEDCONNECTION) then {
            if ((_intercomStatus select STATION_INTERCOM_CONFIGURATION_INDEX) select INTERCOM_STATIONSTATUS_LIMITED) then {
                _changed = [_vehicle, _intercomNetwork, _value, _oldValue] call FUNC(handleLimitedConnection);
            } else {
                _changed = true;
            };

            if (_changed) then {
                if (_value > INTERCOM_DISCONNECTED) then {
                    _intercomStatus set [STATION_INTERCOM_UNIT_INDEX, _unit];
                } else {
                    _intercomStatus set [STATION_INTERCOM_UNIT_INDEX, objNull];
                };
            };
        } else {
            ["Intercom status is being forced. Cannot change configuration.", ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
        };
    };
    case INTERCOM_STATIONSTATUS_VOLUME: { _changed = true };
    case INTERCOM_STATIONSTATUS_LIMITED: { _changed = true };
    case INTERCOM_STATIONSTATUS_TURNEDOUTALLOWED: { _changed = true };
    case INTERCOM_STATIONSTATUS_FORCEDCONNECTION: { _changed = true };
    case INTERCOM_STATIONSTATUS_VOICEACTIVATION: { _changed = true };
    default {  /*...code...*/ };
};

if (_changed) then {
    (_intercomStatus select STATION_INTERCOM_CONFIGURATION_INDEX) set [_intercomFunctionality, _value];
    _vehicle setVariable [_varName, _intercomArray, true];
    [_vehicle, _unit] call FUNC(updateVehicleInfoText);
};
