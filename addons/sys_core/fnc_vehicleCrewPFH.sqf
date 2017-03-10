/*
 * Author: ACRE2Team
 * Per frame execution. Sets if player is inside a vehicle and qualifies as vehicle crew (driver, gunner, turret and commander).
 * Additionally it checks if a unit is using the vehicle's infantry phone.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_core_fnc_vehicleCrewPFH
 *
 * Public: No
 */
#include "script_component.hpp"

private _vehicle = vehicle acre_player;
private _usingInfantryPhone = false;

// The player is not inside a vehicle. Check if it is using the intercom network externally (infantry phone)
if (_vehicle == acre_player) then {
    private _vehicleInfantryPhone = acre_player getVariable [QEGVAR(sys_intercom,vehicleInfantryPhone), objNull];
    if (!isNull _vehicleInfantryPhone) then {
        _vehicle = _vehicleInfantryPhone;
        _usingInfantryPhone = true;
    };

    private _vehiclePassengerIntercom = acre_player getVariable [QEGVAR(sys_intercom,vehiclePassengerIntercom), objNull];
    if (!isNull _vehiclePassengerIntercom) then {
        [_vehiclePassengerIntercom, acre_player, 0] call EFUNC(sys_intercom,updatePassengerIntercomStatus);
    };
};

if (_vehicle != acre_player) then {
    private "_unitInfantryPhone";
    if (_usingInfantryPhone) then {
        // The player is using the intercom externally
        _unitInfantryPhone = acre_player;
    } else {
        // The player is inside the vehicle. Check if a unit is using the intercom externally (infantry phone)
        _unitInfantryPhone = _vehicle getVariable [QEGVAR(sys_intercom,unitInfantryPhone), objNull];
        if (!isNull _unitInfantryPhone) then {
            _usingInfantryPhone = true;
        };
    };

    // The infantry phone can only be used externally
    if (_usingInfantryPhone) then {
        (_vehicle getVariable [QEGVAR(sys_intercom,infantryPhoneInfo), [[0, 0, 0], 10]]) params ["_infantryPhonePosition", "_infantryPhoneMaxDistance"];
        _infantryPhonePosition = _vehicle modelToWorld _infantryPhonePosition;
        private _unitInfantryPhonePosition = ASLToAGL (getPosASL _unitInfantryPhone);
        TRACE_4("Infantry Phone PFH Check",_infantryPhonePosition,_unitInfantryPhonePosition,_infantryPhoneMaxDistance,_unitInfantryPhone distance _infantryPhonePosition);
        // Add an extra meter leeway due to 3d position check height differences and movement
        if (_unitInfantryPhonePosition distance _infantryPhonePosition >= _infantryPhoneMaxDistance + 1 || (vehicle _unitInfantryPhone == _vehicle) || !(alive _unitInfantryPhone) || captive _unitInfantryPhone) then {
            _usingInfantryPhone = false;
            [_vehicle, _unitInfantryPhone, 0] call EFUNC(sys_intercom,updateInfantryPhoneStatus);
        };
    };

    private _crew = [driver _vehicle, gunner _vehicle, commander _vehicle];
    {
        _crew pushBackUnique (_vehicle turretUnit _x);
    } forEach (allTurrets [_vehicle, false]);
    _crew = _crew - [objNull];

    if (acre_player in _crew || _usingInfantryPhone) then {
        ACRE_PLAYER_VEHICLE_CREW = _crew;
        if (_usingInfantryPhone) then {
            // An external unit is using the vehicle intercom network
            ACRE_PLAYER_VEHICLE_CREW pushBackUnique _unitInfantryPhone;
        };
    } else {
        ACRE_PLAYER_VEHICLE_CREW = [];
    };

    private _unitsPassengerIntercom = _vehicle getVariable [QEGVAR(sys_intercom,unitsPassengerIntercom), []];
    if (acre_player in _unitsPassengerIntercom) then {
        // Crew members do not use passenger intercom slots. Activated if a unit was in a passenger seat,
        // and moved to a "crew" position.
        private _availableConnections = _vehicle getVariable [QEGVAR(sys_intercom,availablePassIntercomConn), 0];
        if ((acre_player in _crew) && (acre_player getVariable [QEGVAR(sys_intercom,usesPassengerIntercomConnection), false])) then {
            acre_player setVariable [QEGVAR(sys_intercom,usesPassengerIntercomConnection), false, true];
            _vehicle setVariable [QEGVAR(sys_intercom,availablePassIntercomConn), _availableConnections + 1, true];
        };

        ACRE_PLAYER_PASSENGER_INTERCOM = _unitsPassengerIntercom;

        // Unit moved from a crew seat to a passenger seat and must use available connections
        if (!(acre_player in _crew) && !(acre_player getVariable [QEGVAR(sys_intercom,usesPassengerIntercomConnection), false])) then {
            if (_availableConnections > 0) then {
                _vehicle setVariable [QEGVAR(sys_intercom,availablePassIntercomConn), _availableConnections - 1, true];
                acre_player setVariable [QEGVAR(sys_intercom,usesPassengerIntercomConnection), true, true];
            } else {
                // Remove unit from intercom
                [_vehicle, acre_player, 0] call EFUNC(sys_intercom,updatePassengerIntercomStatus);
                ACRE_PLAYER_PASSENGER_INTERCOM = [];
            };
        };

    } else {
        ACRE_PLAYER_PASSENGER_INTERCOM = [];
    };
} else {
    ACRE_PLAYER_VEHICLE_CREW = [];
};
