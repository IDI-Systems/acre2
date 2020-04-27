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

if ((_varName isEqualTo "") && {_varName = [_vehicle, _unit] call FUNC(getStationVariableName); _varName isEqualTo ""})  exitWith {
    ERROR_2("setStationConfiguration: unit %1 not found in vehicle %2",_unit,_vehicle);
};

private _intercomArray = _vehicle getVariable [_varName, []];
private _intercomStatus = _intercomArray select _intercomNetwork;
private _oldValue = [_intercomStatus, _intercomFunctionality] call CBA_fnc_hashGet;

if (_oldValue isEqualTo _value) exitWith { // Here it is better not to use == since oldValue may be of type null
    TRACE_1("Set the same value for intercom functionality %1",_intercomFunctionality);
};

private _changed = false;
switch (_intercomFunctionality) do {
    case INTERCOM_STATIONSTATUS_CONNECTION: {
        if !([_intercomStatus, INTERCOM_STATIONSTATUS_FORCEDCONNECTION] call CBA_fnc_hashGet) then {
            if ([_intercomStatus, INTERCOM_STATIONSTATUS_LIMITED] call CBA_fnc_hashGet) then {
                _changed = [_vehicle, _intercomNetwork, _value, _oldValue] call FUNC(handleLimitedConnection);
            } else {
                _changed = true;
            };

            if (_changed) then {
                if (_value > INTERCOM_DISCONNECTED) then {
                    [_intercomStatus, "unit", _unit] call CBA_fnc_hashSet;
                } else {
                    [_intercomStatus, "unit", objNull] call CBA_fnc_hashSet;
                };
            };
        } else {
            [[ICON_RADIO_CALL], [localize LSTRING(forcedStatus)]] call CBA_fnc_notify;
        };
    };
    default {
        _changed = true;
    };
};

if (_changed) then {
    GVAR(configChanged) = true;

    [_intercomStatus, _intercomFunctionality, _value] call CBA_fnc_hashSet;
    _vehicle setVariable [_varName, _intercomArray];

    [_vehicle, _unit, _varName] call FUNC(saveStationConfiguration);

    [_vehicle, _unit] call FUNC(updateVehicleInfoText);
};
