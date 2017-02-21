/*
 * Author: ACRE2Team
 * Per frame execution. Sets if player is inside a vehicle and qualifies as vehicle crew (driver, gunner, turret and commander).
 * Additionally it checks if a unit is using the intercom externally
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
private "_vehicleIntercom";
private _usingIntercomExternally = false;

// The player is not inside a vehicle. Check if it is using the intercom network externally
if (_vehicle == acre_player) then {
    private _vehicleIntercom = acre_player getVariable ["vehicleIntercom", nil];
    if (!isNil "_vehicleIntercom") then {
        _vehicle = _vehicleIntercom;
        _usingIntercomExternally = true;
    };
};

if (_vehicle != acre_player) then {
    private "_externalIntercomUnit";
    if (_usingIntercomExternally) then {
        // The player is using the intercom externally
        _externalIntercomUnit = acre_player;
    } else {
        // The player is inside the vehicle. Check if a unit is using the intercom externally
        _externalIntercomUnit = _vehicle getVariable ["intercomUnit", nil];
        if (!isNil "_externalIntercomUnit") then {
            _usingIntercomExternally = true;
        };
    };

    // The intercom can only be used externally up to a distance of 5m
    if (_usingIntercomExternally) then {
        if ((_externalIntercomUnit distance _vehicle > 10.0) || (vehicle _externalIntercomUnit == _vehicle) || !(alive _externalIntercomUnit)) then {
            _usingIntercomExternally = false;
            [_vehicle, _externalIntercomUnit, 0] call FUNC(updateInfantryPhoneStatus);
        };
    };

    private _crew = [driver _vehicle, gunner _vehicle, commander _vehicle];
    {
        _crew pushBackUnique (_vehicle turretUnit _x);
    } forEach (allTurrets [_vehicle, false]);
    _crew = _crew - [objNull];

    if (acre_player in _crew || _usingIntercomExternally) then {
        ACRE_PLAYER_VEHICLE_CREW = _crew;
        if (_usingIntercomExternally) then {
            // An external unit is using the vehicle intercom network
            ACRE_PLAYER_VEHICLE_CREW pushBackUnique _externalIntercomUnit;
        };
    } else {
        ACRE_PLAYER_VEHICLE_CREW = [];
    };
} else {
    ACRE_PLAYER_VEHICLE_CREW = [];
};
