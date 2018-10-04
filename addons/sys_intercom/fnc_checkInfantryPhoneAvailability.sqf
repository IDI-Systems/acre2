#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Check if intercom option is available on infantry units.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * Interaction Available <BOOL>
 *
 * Example:
 * [] call acre_sys_intercom_fnc_checkInfantryPhoneAvailability
 *
 * Public: No
 */

params ["_player"];

!isNull (_player getVariable [QGVAR(vehicleInfantryPhone), [objNull, objNull]] select 0)
