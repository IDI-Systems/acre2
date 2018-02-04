/*
 * Author: ACRE2Team
 * Retrieves the current intercom volume of the given unit.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>. Default: objNull.
 * 1: Unit <OBJECT>. Default: objNull.
 * 2: Intercom network <NUMBER or STRING>. Default: 0.
 * 3: Seat <ARRAY>. Default: [].
 *
 * Return Value:
 * Intercom volume in [0,1]. -1 if it could not be retrieved <NUMBER>
 *
 * Example:
 * [vehicle acre_player, acre_player,"intercom_1"] call acre_api_fnc_getIntercomStationVolume
 * [vehicle acre_player, objNull,"intercom_1", ["turret"], [1]] call acre_api_fnc_getIntercomStationVolume
 * [vehicle acre_player, objNull, 2, ["cargo"], 1] call acre_api_fnc_getIntercomStationVolume
 * [objNull, acre_player, 0] call acre_api_fnc_getIntercomStationVolume
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull], ["_unit", objNull], ["_intercomNetwork", 0], ["_seat", []]];

private _arguments = [_vehicle, _unit, _intercomNetwork, _seat] call FUNC(helperValidateIntercomArguments);

if (_arguments isEqualTo []) then {
    -1
} else {
    [_arguments select 0, _arguments select 1, _arguments select 2, INTERCOM_STATIONSTATUS_CONNECTION, _arguments select 3] call EFUNC(sys_intercom,getStationConfiguration)
};
