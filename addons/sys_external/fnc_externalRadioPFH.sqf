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

private _remove = [];

if (alive acre_player) then {
    // Check if we need to remove active radios
    private _radios = [acre_player] call EFUNC(sys_core,getGear);
    {
        // If the radio is in the players inventory, radio is no longer remote.
        if (_x in _radios) exitWith {_remove pushBackUnique _x;};

        // Remove the external radio if distance is greater than 2m or owner and user are not in the same vehicle.
        if (!([_x] call FUNC(isExternalRadioAvailable))) then {
            _remove pushBackUnique _x;
        };

        if (captive acre_player) then {
            _remove pushBackUnique _x;
        };
    } forEach ACRE_ACTIVE_EXTERNAL_RADIOS;

    // Remove the actual radios
    if (count _remove > 0 ) then {
        {
            if (ACRE_ACTIVE_RADIO == ACRE_BROADCASTING_RADIOID) then {
                // simulate a key up event to end the current transmission
                [] call EFUNC(sys_core,handleMultiPttKeyPressUp);
            };
            [_x] call FUNC(stopUsingExternalRadio);
            [1] call EFUNC(sys_list,cycleRadios); // Change active radio
        } forEach _remove;
    };
} else {
    // All external radios in use are now returned to the owner.
    {
        [_x] call FUNC(stopUsingExternalRadio);
    } forEach ACRE_ACTIVE_EXTERNAL_RADIOS;

    // Mark all the radios as shared
    // private _radios = [acre_player] call EFUNC(sys_core,getGear);
    // _radioList = _radios select {_x call EFUNC(sys_radio,isUniqueRadio)};

    //{
    //    [_x, true] call FUNC(allowExternalUse);
    //} forEach _radioList;
};
