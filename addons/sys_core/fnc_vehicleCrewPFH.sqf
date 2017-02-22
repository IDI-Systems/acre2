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
private _usingIntercomExternally = false;

// The player is not inside a vehicle. Check if it is using the intercom network externally
if (_vehicle == acre_player) then {
    private _vehicleInfantryPhone = acre_player getVariable ["vehicleInfantryPhone", nil];
    if (!isNil "_vehicleInfantryPhone") then {
        _vehicle = _vehicleInfantryPhone;
        _usingIntercomExternally = true;
    };
};

if (_vehicle != acre_player) then {
    private "_unitInfantryPhone";
    if (_usingIntercomExternally) then {
        // The player is using the intercom externally
        _unitInfantryPhone = acre_player;
    } else {
        // The player is inside the vehicle. Check if a unit is using the intercom externally
        _unitInfantryPhone = _vehicle getVariable ["unitInfantryPhone", nil];
        if (!isNil "_unitInfantryPhone") then {
            _usingIntercomExternally = true;
        };
    };

    // The intercom can only be used externally up to a distance of 5m
    if (_usingIntercomExternally) then {
        if ((_unitInfantryPhone distance _vehicle > 5.0) || (vehicle _unitInfantryPhone == _vehicle) || !(alive _unitInfantryPhone)) then {
            _usingIntercomExternally = false;
            [_vehicle, _unitInfantryPhone, 0] call FUNC(updateInfantryPhoneStatus);
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
            ACRE_PLAYER_VEHICLE_CREW pushBackUnique _unitInfantryPhone;
        };
    } else {
        ACRE_PLAYER_VEHICLE_CREW = [];
    };
} else {
    ACRE_PLAYER_VEHICLE_CREW = [];
};
