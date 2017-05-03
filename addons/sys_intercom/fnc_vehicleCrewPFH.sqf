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
        _infantryPhoneNetwork = _infantryPhone select 1;
    };

    // The infantry phone can only be used externally
    if (_usingInfantryPhone || {!_usingInfantryPhone && _unitInfantryPhone == acre_player}) then {
        (_vehicle getVariable [QGVAR(infantryPhoneInfo), [[0, 0, 0], 10]]) params ["_infantryPhonePosition", "_infantryPhoneMaxDistance"];
        _infantryPhonePosition = _vehicle modelToWorld _infantryPhonePosition;
        private _unitInfantryPhonePosition = ASLToAGL (getPosASL _unitInfantryPhone);
        TRACE_4("Infantry Phone PFH Check",_infantryPhonePosition,_unitInfantryPhonePosition,_infantryPhoneMaxDistance,_unitInfantryPhone distance _infantryPhonePosition);
        // Add an extra meter leeway due to 3d position check height differences and movement
        if (_unitInfantryPhonePosition distance _infantryPhonePosition >= _infantryPhoneMaxDistance + 1 || {vehicle _unitInfantryPhone == _vehicle} || {!alive _unitInfantryPhone} || {captive _unitInfantryPhone}) then {
            [_vehicle, _unitInfantryPhone, 0, _infantryPhoneNetwork] call FUNC(updateInfantryPhoneStatus);

            // Reset in case the infantry phone user is now inside the vehicle
            _infantryPhoneNetwork = NO_INTERCOM;
            _usingInfantryPhone = false;
            _unitInfantryPhone = objNull;
        };
    };

    private _unitsCrewIntercom = _vehicle getVariable [QGVAR(unitsCrewIntercom), []];
    private _unitsPassengerIntercom = _vehicle getVariable [QGVAR(unitsPassengerIntercom), []];

    if (acre_player != _unitInfantryPhone) then {
        private _connectionStatus = [_vehicle, acre_player] call FUNC(getIntercomConnectionStatus);
        private _changes = false;

        if (_connectionStatus == NO_INTERCOM) then {
            if (acre_player in _unitsCrewIntercom) then {
                [_vehicle, acre_player, 0] call FUNC(updateCrewIntercomStatus);
                _changes = true;
            };

            if (acre_player in _unitsPassengerIntercom) then {
                [_vehicle, acre_player, 0] call FUNC(updatePassengerIntercomStatus);
                _changes = true;
            };
        };

        if (_connectionStatus == CREW_INTERCOM) then {
            if (!(acre_player in _unitsCrewIntercom)) then {
                [_vehicle, acre_player, 1] call FUNC(updateCrewIntercomStatus);
                _changes = true;
            };

            if (acre_player in _unitsPassengerIntercom) then {
                [_vehicle, acre_player, 0] call FUNC(updatePassengerIntercomStatus);
                _changes = true;
            };
        };

        if (_connectionStatus == PASSENGER_INTERCOM) then {
            if (acre_player in _unitsCrewIntercom) then {
                [_vehicle, acre_player, 0] call FUNC(updateCrewIntercomStatus);
                _changes = true;
            };

            if (!(acre_player in _unitsPassengerIntercom)) then {
                [_vehicle, acre_player, 1] call FUNC(updatePassengerIntercomStatus);
                _changes = true;
            };
        };

        if (_connectionStatus == CREW_AND_PASSENGER_INTERCOM) then {
            if (!(acre_player in _unitsCrewIntercom)) then {
                [_vehicle, acre_player, 1] call FUNC(updateCrewIntercomStatus);
                _changes = true;
            };

            if (!(acre_player in _unitsPassengerIntercom)) then {
                [_vehicle, acre_player, 1] call FUNC(updatePassengerIntercomStatus);
                _changes = true;
            };
        };

        // Update intercom connection status
        if (_changes) then {
            [_vehicle, acre_player] call FUNC(setIntercomConnectionStatus);
        };
    };

    if (acre_player in _unitsCrewIntercom) then {
        // Check if the unit is in a valid intercom position
        if ([_vehicle, acre_player, CREW_INTERCOM] call FUNC(isIntercomAvailable) || (_unitInfantryPhone == acre_player && _infantryPhoneNetwork == CREW_INTERCOM)) then {
            ACRE_PLAYER_CREW_INTERCOM = _unitsCrewIntercom;
        } else {
            if (acre_player == _unitInfantryPhone) then {
                [_vehicle, acre_player, 0] call FUNC(updateCrewIntercomStatus);
            };

            ACRE_PLAYER_CREW_INTERCOM = [];
        };
    } else {
        if (_unitInfantryPhone == acre_player && _infantryPhoneNetwork == CREW_INTERCOM) then {
            _unitsCrewIntercom pushBackUnique _unitInfantryPhone;
            ACRE_PLAYER_CREW_INTERCOM = _unitsCrewIntercom;
            _vehicle setVariable [QGVAR(unitsCrewIntercom), _unitsCrewIntercom, true];
        } else {
            ACRE_PLAYER_CREW_INTERCOM = [];
        };
    };

    if (acre_player in _unitsPassengerIntercom) then {
        // Check if the unit is in a valid intercom position
        if ([_vehicle, acre_player, PASSENGER_INTERCOM] call FUNC(isIntercomAvailable) || (_unitInfantryPhone == acre_player && _infantryPhoneNetwork == PASSENGER_INTERCOM)) then {
            ACRE_PLAYER_PASSENGER_INTERCOM = _unitsPassengerIntercom;
        } else {
            if (acre_player == _unitInfantryPhone) then {
                [_vehicle, acre_player, 0] call FUNC(updatePassengerIntercomStatus);
            };

            ACRE_PLAYER_PASSENGER_INTERCOM = [];
        };
    } else {
        if (_unitInfantryPhone == acre_player && _infantryPhoneNetwork == PASSENGER_INTERCOM) then {
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
        // Remove unit from the list of crew intercom units
        [_vehicleCrewIntercom, acre_player, 0] call FUNC(updateCrewIntercomStatus);
    };
    ACRE_PLAYER_CREW_INTERCOM = [];

    private _vehiclePassengerIntercom = acre_player getVariable [QGVAR(vehiclePassengerIntercom), objNull];
    if (!isNull _vehiclePassengerIntercom) then {
        // Remove unit from the list of passenger intercom units
        [_vehiclePassengerIntercom, acre_player, 0] call FUNC(updatePassengerIntercomStatus);
    };
    ACRE_PLAYER_PASSENGER_INTERCOM = [];
};
