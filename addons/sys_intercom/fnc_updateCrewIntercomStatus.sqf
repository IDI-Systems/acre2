/*
 * Author: ACRE2Team
 * Updates the status of the crew intercom of a vehicle.
 *
 * Arguments:
 * 0: Vehicle with crew intercom <OBJECT>
 * 1: Unit using the crew intercom <OBJECT>
 * 2: Type of action <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player, 1] call acre_sys_intercom_updateCrewIntercomStatus
 *
 * Public: No
 */

#include "script_component.hpp"

params ["_vehicle", "_unit", "_action"];

private _unitsCrewIntercom = _vehicle getVariable [QGVAR(unitsCrewIntercom), []];

if (_action == 0) then {
    // Disconnect from crew intercom
    _unitsCrewIntercom = _unitsCrewIntercom - [_unit];

    _unit setVariable [QGVAR(vehicleCrewIntercom), objNull, true];
    _vehicle setVariable [QGVAR(unitsCrewIntercom), _unitsCrewIntercom, true];
    [localize LSTRING(crewIntercomDisconnected), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);

    if (vehicle _unit != _unit) then {
        // Update intercom connection status
        [_vehicle, _unit] call FUNC(setIntercomConnectionStatus);
    };
} else {
    // Connect to crew intercom
    if ([_vehicle, _unit, CREW_INTERCOM] call FUNC(isIntercomAvailable)) then {
        _unitsCrewIntercom pushBackUnique _unit;

        _unit setVariable [QGVAR(vehicleCrewIntercom), _vehicle, true];
        _vehicle setVariable [QGVAR(unitsCrewIntercom), _unitsCrewIntercom, true];
        [localize LSTRING(crewIntercomConnected), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);

        // Do not update for infantry phone
        if (_unit != ((_vehicle getVariable [QGVAR(unitInfantryPhone), [objNull, NO_INTERCOM]]) select 0)) then {
            // Update intercom connection status
            [_vehicle, _unit] call FUNC(setIntercomConnectionStatus);
        };
    };
};
