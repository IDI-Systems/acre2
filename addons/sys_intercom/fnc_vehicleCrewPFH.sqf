/*
 * Author: ACRE2Team
 * Per frame execution. Sets if player is inside a vehicle and qualifies as vehicle crew or passenger.
 * Additionally it checks if a unit is using the vehicle's infantry phone.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_intercom_fnc_vehicleCrewPFH
 *
 * Public: No
 */
#include "script_component.hpp"

private _vehicle = vehicle acre_player;
private _usingInfantryPhone = false;
private _infantryPhoneNetwork = NO_INTERCOM;

// The player is not inside a vehicle. Check if it is using the intercom network externally (infantry phone)
if (_vehicle == acre_player) then {
    private _infantryPhone = acre_player getVariable [QGVAR(vehicleInfantryPhone), [objNull, NO_INTERCOM]];
    private _vehicleInfantryPhone = _infantryPhone select 0;
    if (!isNull _vehicleInfantryPhone) then {
        _vehicle = _vehicleInfantryPhone;
        _infantryPhoneNetwork = _infantryPhone select 1;
        _usingInfantryPhone = true;
    };
};

if (_vehicle != acre_player) then {
    private "_unitInfantryPhone";
    if (_usingInfantryPhone) then {
        // The player is using the intercom externally
        _unitInfantryPhone = acre_player;
    } else {
        // The player is inside the vehicle. Check if a unit is using the intercom externally (infantry phone)
        private _infantryPhone = _vehicle getVariable [QGVAR(unitInfantryPhone), [objNull, NO_INTERCOM]];
        _unitInfantryPhone = _infantryPhone select 0;
        if (!isNull _unitInfantryPhone) then {
            _infantryPhoneNetwork = _infantryPhone select 1;
            _usingInfantryPhone = true;
        };
    };

    // The infantry phone can only be used externally
    if (_infantryPhoneNetwork > 0) then {
        (_vehicle getVariable [QGVAR(infantryPhoneInfo), [[0, 0, 0], 10]]) params ["_infantryPhonePosition", "_infantryPhoneMaxDistance"];
        _infantryPhonePosition = _vehicle modelToWorld _infantryPhonePosition;
        private _unitInfantryPhonePosition = ASLToAGL (getPosASL _unitInfantryPhone);
        TRACE_4("Infantry Phone PFH Check",_infantryPhonePosition,_unitInfantryPhonePosition,_infantryPhoneMaxDistance,_unitInfantryPhone distance _infantryPhonePosition);
        // Add an extra meter leeway due to 3d position check height differences and movement
        if (_unitInfantryPhonePosition distance _infantryPhonePosition >= _infantryPhoneMaxDistance + 1 || (vehicle _unitInfantryPhone == _vehicle) || !(alive _unitInfantryPhone) || captive _unitInfantryPhone) then {
            if (_infantryPhoneNetwork == PASSENGER_INTERCOM) then {
                [_vehicle, acre_player, 0] call FUNC(updatePassengerIntercomStatus);
                ACRE_PLAYER_PASSENGER_INTERCOM = [];
            };
            _infantryPhoneNetwork = NO_INTERCOM;
            [_vehicle, _unitInfantryPhone, 0, _infantryPhoneNetwork] call FUNC(updateInfantryPhoneStatus);
        };
    };

    private _unitsCrewIntercom = _vehicle getVariable [QGVAR(unitsCrewIntercom), []];
    if (!(acre_player in _unitsCrewIntercom)) then {
        if ([_vehicle, acre_player, CREW_INTERCOM] call FUNC(isIntercomAvailable) || (_infantryPhoneNetwork == CREW_INTERCOM)) then {
            // Add unit to intercom
            _unitsCrewIntercom pushBackUnique acre_player;
            _vehicle setVariable [QGVAR(unitsCrewIntercom), _unitsCrewIntercom, true];
            ACRE_PLAYER_VEHICLE_CREW = _unitsCrewIntercom;
            acre_player setVariable [QGVAR(vehicleCrewIntercom), _vehicle, true];

            if (acre_player != _unitInfantryPhone) then {
                [localize LSTRING(crewIntercomConnected), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
            };
        } else {
            ACRE_PLAYER_VEHICLE_CREW = [];
            if (!isNull (acre_player getVariable [QGVAR(vehiclePassengerIntercom), objNull])) then {
                // Player switchet to a non intercom position
                acre_player setVariable [QGVAR(vehicleCrewIntercom), objNull, true];
            };
        };
    } else {
        // Check if the unit is in a valid intercom position
        if ([_vehicle, acre_player, CREW_INTERCOM] call FUNC(isIntercomAvailable) || (_infantryPhoneNetwork == CREW_INTERCOM)) then {
            ACRE_PLAYER_VEHICLE_CREW = _unitsCrewIntercom;
        } else {
            ACRE_PLAYER_VEHICLE_CREW = [];
            _unitsCrewIntercom = _unitsCrewIntercom - [acre_player];
            _vehicle setVariable [QGVAR(unitsCrewIntercom), _unitsCrewIntercom, true];
            [localize LSTRING(crewIntercomDisconnected), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
        };
    };

    private _unitsPassengerIntercom = _vehicle getVariable [QGVAR(unitsPassengerIntercom), []];
    if (acre_player in _unitsPassengerIntercom) then {
        if ([_vehicle, acre_player, PASSENGER_INTERCOM] call FUNC(isIntercomAvailable) || (_infantryPhoneNetwork == PASSENGER_INTERCOM)) then {
            ACRE_PLAYER_PASSENGER_INTERCOM = _unitsPassengerIntercom;

            // These actions are not for units with infantry phones
            if (acre_player != _unitInfantryPhone) then {
                // Crew members do not use passenger intercom slots. Activated if a unit was in a passenger seat, and moved to a "crew" position.
                private _availableConnections = _vehicle getVariable [QGVAR(availablePassIntercomConn), 0];
                if ((acre_player in _unitsCrewIntercom) && (acre_player getVariable [QGVAR(usesPassengerIntercomConnection), false])) then {
                    acre_player setVariable [QGVAR(usesPassengerIntercomConnection), false, true];
                    _vehicle setVariable [QGVAR(availablePassIntercomConn), _availableConnections + 1, true];
                };

                // Unit moved from a crew seat to a passenger seat and must use available connections
                if (!(acre_player in _unitsCrewIntercom) && !(acre_player getVariable [QGVAR(usesPassengerIntercomConnection), false])) then {
                    if (_availableConnections > 0) then {
                        _vehicle setVariable [QGVAR(availablePassIntercomConn), _availableConnections - 1, true];
                        acre_player setVariable [QGVAR(usesPassengerIntercomConnection), true, true];
                    } else {
                        // Remove unit from intercom
                        [_vehicle, acre_player, 0] call FUNC(updatePassengerIntercomStatus);
                        ACRE_PLAYER_PASSENGER_INTERCOM = [];
                    };
                };
            };
        } else {
            // Position does not have passenger intercom. Removing unit from the list.
            [_vehicle, acre_player, 0] call FUNC(updatePassengerIntercomStatus);
            ACRE_PLAYER_PASSENGER_INTERCOM = [];
        };
    } else {
        if (_infantryPhoneNetwork == PASSENGER_INTERCOM) then {
            _unitsPassengerIntercom pushBackUnique _unitInfantryPhone;
            ACRE_PLAYER_PASSENGER_INTERCOM = _unitsPassengerIntercom;
            _vehicle setVariable [QGVAR(unitsPassengerIntercom), _unitsPassengerIntercom, true];
        } else {
            ACRE_PLAYER_PASSENGER_INTERCOM = [];
        };
    };

} else {
    private _vehicleCrewIntercom = acre_player getVariable [QGVAR(vehicleCrewIntercom), objNull];
    if (!isNull _vehicleCrewIntercom) then {
        // Remove unit from the list of intercom units
        private _unitsCrewIntercom = _vehicleCrewIntercom getVariable [QGVAR(unitsCrewIntercom), []];
        _unitsCrewIntercom = _unitsCrewIntercom - [acre_player];
        _vehicleCrewIntercom setVariable [QGVAR(unitsCrewIntercom), _unitsCrewIntercom, true];
        acre_player setVariable [QGVAR(vehicleCrewIntercom), objNull, true];
        [localize LSTRING(crewIntercomDisconnected), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
    ACRE_PLAYER_VEHICLE_CREW = [];

    private _vehiclePassengerIntercom = acre_player getVariable [QGVAR(vehiclePassengerIntercom), objNull];
    if (!isNull _vehiclePassengerIntercom) then {
        [_vehiclePassengerIntercom, acre_player, 0] call FUNC(updatePassengerIntercomStatus);
    };
    ACRE_PLAYER_PASSENGER_INTERCOM = [];
};
