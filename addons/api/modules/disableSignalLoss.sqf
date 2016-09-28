/*
 * Author: ACRE2Team
 * For use by the ACRE API disableSignalLoss module.
 *
 * Arguments:
 * 0: Logic <OBJECT>
 * 1: Units <ARRAY>
 * 2: Activated <BOOLEAN>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AcreModules_fnc_disableSignalLoss;
 *
 * Public: No
 */
#include "script_component.hpp"

[0.0] call acre_api_fnc_setLossModelScale;