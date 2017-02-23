/*
 * Author: ACRE2Team
 * Check if intercom option is available on infantry units.
 *
 * Arguments:
 * 0: Player <OBJECT>
 *
 * Return Value:
 * ACE interaction is available <BOOL>
 *
 * Example:
 * [] call acre_sys_intercom_fnc_checkInfantryPhoneAvailability
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_player"];

!isNull (_player getVariable [QGVAR(vehicleInfantryPhone), objNull])
