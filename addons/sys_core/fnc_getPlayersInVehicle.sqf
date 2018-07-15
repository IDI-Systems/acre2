/*
 * Author: ACRE2Team
 * Returns all player units inside a vehicle.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Player units inside a vehicle <ARRAY>
 *
 * Example:
 * [cursorTarget] call acre_sys_core_fnc_getPlayersInVehicle
 *
 * Public: No
 */

params ["_vehicle"];

private _fullCrew = fullCrew [_vehicle, "", false];

private _playersInVehicle = [];

{
    private _unit = _x select 0;
    if (!isNull _unit && {isPlayer _unit}) then {
        _playersInVehicle pushBack _unit;
    };
} forEach _fullCrew;

_playersInVehicle
