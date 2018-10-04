#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Returns the rack IDs for a specific vehicle that a player can hear.
 *
 * Arguments:
 * 0: Target Vehicle <OBJECT>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * Hearable racks <ARRAY>
 *
 * Example:
 * [vehicle acre_player, acre_player] call acre_sys_rack_fnc_getHearableVehicleRacks
 *
 * Public: No
 */

params ["_vehicle", "_unit"];

(_vehicle getVariable [QGVAR(vehicleRacks), []]) select {[_x, _unit, _vehicle] call FUNC(isRackHearable)}
