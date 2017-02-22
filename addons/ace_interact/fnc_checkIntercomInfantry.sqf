/*
 * Author: ACRE2Team
 * Check if intercom option is available on infantry units.
 *
 * Arguments:
 * None
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

!isNil {acre_player getVariable ["vehicleInfantryPhone", nil]}
