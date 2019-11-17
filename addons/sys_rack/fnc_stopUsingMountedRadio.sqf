#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles a player when they opt to stop using a mounted radio. Safely handles off usage of the radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle acre_player, acre_player, "ACRE_PRC152_ID_1"] call acre_sys_rack_fnc_stopUsingMountedRadio
 *
 * Public: No
 */

params ["_vehicle", "_unit", "_radioId"];

if (_radioId in ACRE_ACCESSIBLE_RACK_RADIOS) then {
    ACRE_ACCESSIBLE_RACK_RADIOS deleteAt (ACRE_ACCESSIBLE_RACK_RADIOS find _radioId);
} else {
    ACRE_HEARABLE_RACK_RADIOS deleteAt (ACRE_HEARABLE_RACK_RADIOS find _radioId);
};

[_radioId] call EFUNC(sys_radio,stopUsingRadio);

// Update the display
[_vehicle, _unit] call EFUNC(sys_intercom,updateVehicleInfoText);
