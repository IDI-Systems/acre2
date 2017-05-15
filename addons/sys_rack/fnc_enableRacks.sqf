/*
 * Author: ACRE2Team
 * Enables racks in a vehicle
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_rack_fnc_disableRacks
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

_vehicle setVariable [QGVAR(disabledRacks), false, true];

[localize LSTRING(sys_rack,racksEnabled), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
