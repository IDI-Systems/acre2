#include "script_component.hpp"
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

params ["_vehicle"];

_vehicle getVariable [QGVAR(vehicleRacks), []]
