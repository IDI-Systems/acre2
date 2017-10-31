/*
 * Author: ACRE2Team
 * Handles a player when they opt to start using a mounted radio.
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

private _isRadioAccessible = [_radioId, _unit] call FUNC(isRadioAccessible);
private _isRadioHearable = [_radioId, _unit] call FUNC(isRadioHearable);

if (_isRadioAccessible) then {
    ACRE_ACCESSIBLE_RACK_RADIOS pushBackUnique _radioId;
};

if (_isRadioHearable && !_isRadioAccessible) then {
    ACRE_HEARABLE_RACK_RADIOS pushBackUnique _radioId;
};

// Set active radio
ACRE_ACTIVE_RADIO = _radioId;

if (_isRadioHearable) then {
    // Check if the radio had already some functionality in order to avoid overwritting it.
    private _functionality = [_radioId, _vehicle, _unit] call EFUNC(sys_intercom,getRxTxCapabilities);
    if (_functionality == RACK_NO_MONITOR) then {
        // Set as default RX and TX functionality
        [_radioId, _vehicle, _unit, RACK_RX_AND_TX] call EFUNC(sys_intercom,setRxTxCapabilities);
    };
};
