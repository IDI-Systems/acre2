/*
 * Author: ACRE2Team
 * Eventhandler to monitor if external radios can be still used by a specific player.
 *
 * - Disabled uses of external radios are:
 *   - Radio is in players inventory.
 *   - Player is dead. External radios are returned to the original owner.
 *   - Distance between owner and end user is greater than 2m.
 *   - Owner and end user are not in the same vehicle.
 * - Radios in dead or captive units can always be accessed by other players.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_sys_external_externalRadioPFH
 *
 * Public: No
 */
#include "script_component.hpp"

/* TODO:
 * - Consider further corner cases.
 */

if (alive acre_player) then {
    // Check if we need to remove active radios
    private _radios = [acre_player] call EFUNC(sys_core,getGear);
    {
        // Remove radios that are in unit's inventory or match a certain criteria.
        private _owner = [_x] call FUNC(getExternalRadioOwner);
        private _isExternalRadioAvailable = [_x, _owner] call FUNC(isExternalRadioAvailable);
        if ((_x in _radios) || !_isExternalRadioAvailable) then {
            [_x, _owner] call FUNC(stopUsingExternalRadio);
        };
    } forEach ACRE_ACTIVE_EXTERNAL_RADIOS;
} else {
    // All external radios in use are now returned to the owner.
    {
        private _owner = [_x] call FUNC(getExternalRadioOwner);
        [_x, _owner] call FUNC(stopUsingExternalRadio);
    } forEach ACRE_ACTIVE_EXTERNAL_RADIOS;
};
