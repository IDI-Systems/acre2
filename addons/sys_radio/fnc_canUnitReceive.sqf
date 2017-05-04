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
    if (_radioId in ACRE_ACCESSIBLE_RACK_RADIOS || _radioId in ACRE_HEARABLE_RACK_RADIOS) then {

        // Check if radio is in intercom.
        if ([_radioId, acre_player, _vehicle] call EFUNC(sys_rack,isRadioHearable)) then {
            private _rackRxTxConfig = _vehicle getVariable [QEGVAR(sys_intercom,rackRxTxConfig), []];
            private _functionality = [_radioId, _vehicle, acre_player] call EFUNC(sys_intercom,getRxTxCapabilities);
            if (_functionality == RACK_NO_MONITOR || _functionality == RACK_TX_ONLY) then {
                _canReceive = false;
            };
        };
    };
};

if (_canReceive && {_radioId in ACRE_EXTERNALLY_USED_PERSONAL_RADIOS}) then {
    _canReceive = false;
};

_canReceive
