/*
 * Author: ACRE2Team
 * Updates the status of the infantry phone of a vehicle.
 *
 * Arguments:
 * 0: Vehicle with intercom <OBJECT>
 * 1: Unit using the infantry phone <OBJECT>
 * 2: Type of action <NUMBER>
 * 3: Intercom network <NUMBER>
 * 4: Unit giving the infantry phone <OBJECT> (default: objNull)
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget, player, 1, CREW_INTERCOM] call acre_sys_intercom_updateInfantryPhoneStatus
 * [cursorTarget, infantryUnit, 1, PASSENGER_INTERCOM, player] call acre_sys_intercom_updateInfantryPhoneStatus
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_action", ["_intercomNetwork", CREW_INTERCOM], ["_givingUnit", objNull, [objNull]]];

private "_intercomText";
switch (_intercomNetwork) do {
    case CREW_INTERCOM: {_interComText = "(" + localize CREW_STRING + ")";};
    case PASSENGER_INTERCOM: {_interComText = "(" + localize LSTRING(passenger) + ")";};
};

switch (_action) do {
    case 0: {
        // Stop using the intercom externally
        _vehicle setVariable [QGVAR(unitInfantryPhone), nil, true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), nil, true];
        if (_intercomNetwork == PASSENGER_INTERCOM) then {
            [_vehicle, _unit, 0] call FUNC(updatePassengerIntercomStatus);
        };
        [format [localize LSTRING(infantryPhoneDisconnected), _intercomText], ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
    case 1: {
        // Start using the intercom externally
        _vehicle setVariable [QGVAR(unitInfantryPhone), [_unit, _intercomNetwork], true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), [_vehicle, _intercomNetwork], true];
        [format [localize LSTRING(infantryPhoneConnected), _intercomText], ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
    case 2: {
        // Give the intercom to another unit
        _vehicle setVariable [QGVAR(unitInfantryPhone), [_unit, _intercomNetwork], true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), [_vehicle, _intercomNetwork], true];
        _givingUnit setVariable [QGVAR(vehicleInfantryPhone), nil, true];
        [format [localize LSTRING(infantryPhoneReceived), _intercomText], ICON_RADIO_CALL, nil, _unit] call EFUNC(sys_core,displayNotification);
    };
    case 3: {
        // Switch to another intercom network
        _vehicle setVariable [QGVAR(unitInfantryPhone), [_unit, _intercomNetwork], true];
        _unit setVariable [QGVAR(vehicleInfantryPhone), [_vehicle, _intercomNetwork], true];
    };
};

// Hook for third party mods with actions when picking returning infantry phone
private _event = _vehicle getVariable [QGVAR(eventInfantryPhone), ""];
if (_event != "") then {
    _event = missionNamespace getVariable [_event, {}];
    if (_event isEqualType {} && !(_event isEqualTo {})) then {
        [_vehicle, _unit, _action] call _event;
    };
};
