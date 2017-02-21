/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit using the intercom externally <OBJECT>
 * 2: Type of action <NUMBER>
 * 3: Unit giving the intercom telephone <OBJECT><OPTIONAL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player, 1] call acre_sys_core_updateExternalIntercomStatus
 * [cursorTarget, infantryUnit, 1, player] call acre_sys_core_updateExternalIntercomStatus
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_intercomUnit", "_action", "_givingUnit"];

switch (_action) do {
    case 0: {
        // Stop using the intercom externally
        [_vehicle, ["intercomUnit", nil, true]] remoteExecCall ["setVariable", _vehicle];
        _intercomUnit setVariable ["vehicleIntercom", nil, true];
        systemChat format ["Stop using intercom of vehicle %1", _vehicle];
    };

    case 1: {
        [_vehicle, ["intercomUnit", _intercomUnit, true]] remoteExecCall ["setVariable", _vehicle];
        _intercomUnit setVariable ["vehicleIntercom", _vehicle, true];
        systemChat format ["Start using intercom of vehicle %1", _vehicle];
    };

    case 2: {
        // Give the intercom to another unit
        [_vehicle, ["intercomUnit", _intercomUnit, true]] remoteExecCall ["setVariable", _vehicle];
        [_intercomUnit, ["vehicleIntercom", _vehicle, true]] remoteExecCall ["setVariable", _intercomUnit];
        _givingUnit setVariable ["vehicleIntercom", nil, true];
        systemChat format ["Giving intercom of vehicle %1 to %2", _vehicle, _intercomUnit];
    };
};
