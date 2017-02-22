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
    private _vehicleInfantryPhone = acre_player getVariable ["vehicleInfantryPhone", nil];
    if (!isNil "_vehicleInfantryPhone") then {
        _vehicle = _vehicleInfantryPhone;
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
        _unitInfantryPhone = _vehicle getVariable ["unitInfantryPhone", nil];
        if (!isNil "_unitInfantryPhone") then {
            _usingInfantryPhone = true;
        };
    };

    // The infantry phone can only be used externally up to a distance of 5m
    if (_usingInfantryPhone) then {
        if ((_unitInfantryPhone distance _vehicle > MAX_DISTANCE_INFANTRYPHONE) || (vehicle _unitInfantryPhone == _vehicle) || !(alive _unitInfantryPhone) || captive _unitInfantryPhone) then {
            _usingInfantryPhone = false;
            [_vehicle, _unitInfantryPhone, 0] call FUNC(updateInfantryPhoneStatus);
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
} else {
    ACRE_PLAYER_VEHICLE_CREW = [];
};
