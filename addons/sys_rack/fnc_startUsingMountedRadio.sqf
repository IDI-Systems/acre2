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

params ["_radioId"];

_radioId = toLower _radioId;

private _rackId = toLower ([_radioId] call FUNC(getRackFromRadio));
private _isRackAccessible = [_rackId, acre_player] call FUNC(isRackAccessible);
private _isRackHearable = [_rackId, acre_player] call FUNC(isRackHearable);

if (_isRackAccessible) then {
    ACRE_ACCESSIBLE_RACK_RADIOS pushBackUnique (toLower _radioId);
};

if (_isRackHearable && !_isRackAccessible) then {
    ACRE_HEARABLE_RACK_RADIOS pushBackUnique (toLower _radioId);
};

if (_isRackHearable) then {
    // Check if the radio had already some functionality in order to avoid overwritting it.
    private _vehicle = [_rackId] call FUNC(getVehicleFromRack);
    private _functionality = [_radioId, _vehicle, acre_player, _rackId] call EFUNC(sys_intercom,getRxTxCapabilities);
    if (_functionality == RADIO_NO_MONITOR) then {
        // Set as default RX and TX functionality
        [_radioId, _vehicle, acre_player, RADIO_RX_AND_TX, _rackId] call EFUNC(sys_intercom,setRxTxCapabilities);
    };
};
