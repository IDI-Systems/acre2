#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the rack IDs for a specific vehicle that a player can access.
 *
 * Arguments:
 * 0: Target Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * Accessible racks <ARRAY>
 *
 * Example:
 * [vehicle acre_player, acre_player] call acre_sys_rack_fnc_getAccessibleVehicleRacks
 *
 * Public: No
 */

params ["_vehicle", "_unit"];

(_vehicle getVariable [QGVAR(vehicleRacks), []]) select {[_x, _unit, _vehicle] call FUNC(isRackAccessible)}
