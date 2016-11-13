/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_rack_fnc_stopUsingMountedRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params["_radioId"];

_radioId = toLower _radioId;
ACRE_ACTIVE_RACK_RADIOS = ACRE_ACTIVE_RACK_RADIOS - [_radioId];
if (ACRE_ACTIVE_RADIO == _radioId) then { // If it is the active radio.
    // Check if radio is now in inventory
    private _items = [acre_player] call EFUNC(lib,getGear);
    _items = _items apply {toLower _x};
    
    if ((toLower ACRE_ACTIVE_RADIO) in _items) exitWith {}; // No need to proceed further as the radio is in player inventory.
    
    // End transmission if broadcasting
    if(ACRE_ACTIVE_RADIO == ACRE_BROADCASTING_RADIOID) then {
        // simulate a key up event to end the current transmission
        [] call EFUNC(sys_core,handleMultiPttKeyPressUp);
    };
    
    // Switch active Radio
    ACRE_ACTIVE_RADIO = "";
    [1] call EFUNC(sys_list,cycleRadios); // Change active radio
};