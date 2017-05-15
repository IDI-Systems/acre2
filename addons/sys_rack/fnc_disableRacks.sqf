/*
 * Author: ACRE2Team
 * Disables racks in a vehicle
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

_vehicle setVariable [QGVAR(disabledRacks), true, true];

[localize LSTRING(sys_rack,racksDisabled), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
