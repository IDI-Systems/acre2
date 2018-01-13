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
 * ["ACRE_PRC152_ID_1"] call acre_sys_rack_fnc_stopUsingMountedRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_vehicle", "_unit", "_radioId"];

if (_radioId in ACRE_ACCESSIBLE_RACK_RADIOS) then {
    ACRE_ACCESSIBLE_RACK_RADIOS deleteAt (ACRE_ACCESSIBLE_RACK_RADIOS find _radioId);
} else {
    ACRE_HEARABLE_RACK_RADIOS deleteAt (ACRE_HEARABLE_RACK_RADIOS find _radioId);
};

// Set intercom configuration to no monitoring.
if ([_radioId, _unit] call FUNC(isRadioHearable)) then {
    [_radioId, _vehicle, _unit, RACK_NO_MONITOR] call EFUNC(sys_intercom,setRxTxCapabilities);
};

[_radioId] call EFUNC(sys_radio,stopUsingRadio);
