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
 * [] call acre_ace_interact_fnc_checkIntercomInfantry
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_player"];

!isNil {_player getVariable [QEGVAR(sys_core,vehicleInfantryPhone), nil]}
