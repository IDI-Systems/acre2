/*
 * Author: ACRE2Team
 * Checks if an action is available for a unit within a vehicle with ACRE2 radios
 *
 * Arguments:
 * 0: Vehicle with ACRE2 radios <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ACRE_PRC343_ID_1", cursorTarget] call acre_ace_interact_fnc_externalRadioVehicleCheckListChildrenActions
 *
 * Public: No
 */
#include "script_component.hpp"

params [_radioId, _unit];

// Only drivers and commanders are allowed to use the radio unless one of the gives it to any member in the vehicle
if (tolower (assignedVehicleRole acre_player) in ["driver","commander"]) then {
    _return = [_radioId, _unit] call FUNC(externalRadioCheckListChildrenActions);
} else {
    _return = false;
}

_return
