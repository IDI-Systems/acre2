#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the case of a unit switching seats in a vehicle with intercom.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit to be checked <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, acre_player] call acre_sys_intercom_fnc_seatSwitched
 *
 * Public: No
 */

params ["_vehicle", "_unit"];
TRACE_2("intercom seatSwitched",_vehicle,_unit);

private _intercomNames = _vehicle getVariable [QGVAR(intercomNames), []];
private _oldSeat = _unit getVariable [QGVAR(role), ""];
private _newSeat = [_vehicle, _unit] call FUNC(getStationVariableName);

// If unit is transmitting through intercom, stop the transmittion during the seat switch
if (GVAR(intercomPTT)) then {
    [ACTION_INTERCOM_PTT] call FUNC(handlePttKeyPressUp);
};

// Same for broadcast messages
if (GVAR(broadcastKey)) then {
    [ACTION_BROADCAST] call FUNC(handlePttKeyPressUp);
};

{
    if (_oldSeat != "") then {
        private _connectionStatus = [_vehicle, _unit, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION, _oldSeat] call FUNC(getStationConfiguration);

        // Remove the unit from the old seat configuration
        if (_connectionStatus > INTERCOM_DISCONNECTED) then {
            private _inLimitedPosition = [_vehicle, _unit, _forEachIndex, INTERCOM_STATIONSTATUS_LIMITED, _oldSeat] call FUNC(getStationConfiguration);

            if (_inLimitedPosition) then { // Disconnect completely if it was a limited position
                [_vehicle, _unit, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION, INTERCOM_DISCONNECTED, _oldSeat] call FUNC(setStationConfiguration);
            } else { // Simply remove the unit from the seat configuration
                [_vehicle, objNull, _forEachIndex, _oldSeat] call FUNC(setStationUnit);
            };
        };
    };

    // Handle the new seat if the player is inside the vehicle
    if (vehicle _unit == _vehicle) then {
        private _connectionStatus = [_vehicle, _unit, _forEachIndex, INTERCOM_STATIONSTATUS_CONNECTION] call FUNC(getStationConfiguration);

        if (_connectionStatus > INTERCOM_DISCONNECTED) then {
            [_vehicle, _unit, _forEachIndex] call FUNC(setStationUnit);
        };
    };
} forEach _intercomNames;

// Save seat on the unit and update vehicle info text
_unit setVariable [QGVAR(role), _newSeat];
[_vehicle, _unit] call FUNC(updateVehicleInfoText);
