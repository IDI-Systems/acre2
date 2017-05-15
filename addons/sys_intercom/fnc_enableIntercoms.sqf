/*
 * Author: ACRE2Team
 * Enables intercom in a vehicle
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorTarget] call acre_sys_intercom_fnc_enableIntercoms
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle"];

_vehicle setVariable [QGVAR(disabledIntercoms), false, true];

[localize LSTRING(intercomsEnabled), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
