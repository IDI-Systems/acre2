/*
 * Author: ACRE2Team
 * Returns whether the radio can be used to receive incoming transmissions.
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 *
 * Return Value:
 * Can transmit throught the radio <BOOL>
 *
 * Example:
 * ["acre_prc152_id_1"] call acre_sys_radio_fnc_canUnitReceive
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId"];

private _canReceive = true;
private _vehicle = vehicle acre_player;

if (_vehicle != acre_player) then {
    if (_radioId in ACRE_ACTIVE_RACK_RADIOS || _radioId in ACRE_PASSIVE_RACK_RADIOS) then {
        // Get rackID
        private _rackId = [_radioId] call EFUNC(sys_rack,getRackFromRadio);

        // Check if radio is in intercom.
        if ([_rackId, acre_player, _vehicle] call EFUNC(sys_rack,isRackHearable)) then {
            private _rackTxRxConfig = _vehicle getVariable [QEGVAR(sys_intercom,rackTxRxConfig), []];
            private _functionality = [_rackId, _vehicle, acre_player] call EFUNC(sys_intercom,getTxRxCapabilities);
            if (_functionality == RACK_NO_MONITOR || _functionality == RACK_TX_ONLY) then {
                ["Receiving disabled", ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
                _canTransmit = false;
            };
        };
    };
};

_canReceive
