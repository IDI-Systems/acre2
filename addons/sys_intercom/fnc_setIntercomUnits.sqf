/*
 * Author: ACRE2Team
 * Adds or removes a unit from the specified intercom network.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 * 2: Intercom network <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, acre_player, 0] call acre_sys_intercom_fnc_setIntercomUnits
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_intercomNetwork", ["_connectionStatus", -1], ["_makePublic", true]];

private _unitsIntercom = _vehicle getVariable [QGVAR(unitsIntercom), []];

if (_connectionStatus == -1) then {
    _connectionStatus = [_vehicle, _unit, _intercomNetwork] call FUNC(getStationConnectionStatus);
};

private _intercomUnits = +(_unitsIntercom select _intercomNetwork);
private _changes = false;

switch (_connectionStatus) do {
    case INTERCOM_DISCONNECTED: {
        if (_unit in _intercomUnits) then {
            // Player is still connected, make it disconnect since the seat has no active intercom connection
            _intercomUnits = _intercomUnits - [_unit];
            _changes = true;
            [format ["Disconnected from %1", (_vehicle getVariable [QGVAR(intercomDisplayNames), []]) select _intercomNetwork], ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
        };
    };
    case INTERCOM_CONNECTED: {
        if (!(_unit in _intercomUnits)) then {
            // Player is still connected, make it disconnect since the seat has no active intercom connection
            _intercomUnits pushBackUnique _unit;
            _changes = true;
            [format ["Connected to %1", (_vehicle getVariable [QGVAR(intercomDisplayNames), []]) select _intercomNetwork], ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
        };
    };
    default {
        WARNING_1("Invalid intercom connection status: %1",_connectionStatus);
    };
};

// Update intercom connection status
if (_changes) then {
    _unitsIntercom set [_intercomNetwork, _intercomUnits];
    _vehicle setVariable [QGVAR(unitsIntercom), _unitsIntercom, _makePublic];
    _unitsIntercom = _vehicle getVariable [QGVAR(unitsIntercom), []];
};
