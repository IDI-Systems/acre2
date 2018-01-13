/*
 * Author: ACRE2Team
 * Handles the situation where the acre_player stops using a racked radio or an external radio.
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc152_id_1"] call acre_sys_radio_fnc_stopUsingRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId"];

// Only do something if the radio is actually the active one
if (ACRE_ACTIVE_RADIO isEqualTo _radioId) then {
    private _items = [acre_player] call EFUNC(sys_core,getGear);

    // Change only the active radio if it is not in the player's inventory
    if (!(ACRE_ACTIVE_RADIO in _items)) then {
        if (ACRE_ACTIVE_RADIO == ACRE_BROADCASTING_RADIOID) then {
            // Simulate a key up event to end the current transmission
            [] call EFUNC(sys_core,handleMultiPttKeyPressUp);
        };

        // Switch active radio, but first reset it
        ACRE_ACTIVE_RADIO = "";
        ACRE_ACTIVE_RADIO = ([] call EFUNC(sys_data,getPlayerRadioList)) select 0;
    };
};
