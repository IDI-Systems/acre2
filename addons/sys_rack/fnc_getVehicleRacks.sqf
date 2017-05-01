/*
 * Author: ACRE2Team
 * Returns the rack IDs for a specific vehicle
 *
 * Arguments:
 * 0: Target Vehicle <OBJECT>
 *
 * Return Value:
 * Racks <ARRAY>
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_fnc_getVehicleRacks
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

private _racks = [];

{
    if (_x isKindOf "ACRE_BaseRack") then {
        _racks pushBack _x;
    };
} forEach (_vehicle getVariable [QGVAR(vehicleRacks), []]);

_racks;
