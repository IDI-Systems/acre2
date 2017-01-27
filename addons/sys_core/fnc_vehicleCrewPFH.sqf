/*
 * Author: ACRE2Team
 * Per frame execution. Sets if player is inside a vehicle and qualifies as vehicle crew (driver, gunner, turret and commander).
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

if (_vehicle != acre_player) then {
    private _crew = [driver _vehicle, gunner _vehicle, commander _vehicle];
    {
        _crew pushBackUnique (_vehicle turretUnit _x);
    } forEach (allTurrets [_vehicle, false]);
    _crew = _crew - [objNull];
    if (acre_player in _crew) then {
        ACRE_PLAYER_VEHICLE_CREW = _crew;
    } else {
        ACRE_PLAYER_VEHICLE_CREW = [];
    };
} else {
    ACRE_PLAYER_VEHICLE_CREW = [];
};
