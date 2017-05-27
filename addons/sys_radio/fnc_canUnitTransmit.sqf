/*
 * Author: ACRE2Team
 * Returns whether the radio can be used to transmit or is only used passively (receive only).
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 *
 * Return Value:
 * Can transmit throught the radio <BOOL>
 *
 * Example:
 * ["acre_prc152_id_1"] call acre_sys_radio_fnc_canUnitTransmit
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId"];

private _canTransmit = true;
private _vehicle = vehicle acre_player;

if (_vehicle != acre_player) then {
    if ((_radioId in ACRE_ACCESSIBLE_RACK_RADIOS || _radioId in ACRE_HEARABLE_RACK_RADIOS) && {[toLower _radioId, acre_player] call EFUNC(sys_rack,isRadioHearable)}) then {
        // Check if radio is in intercom.
        if ([_radioId, acre_player, _vehicle] call EFUNC(sys_rack,isRadioHearable)) then {
            private _rackRxTxConfig = _vehicle getVariable [QEGVAR(sys_intercom,rackRxTxConfig), []];
            private _functionality = [_radioId, _vehicle, acre_player] call EFUNC(sys_intercom,getRxTxCapabilities);
            if (_functionality == RACK_NO_MONITOR || _functionality == RACK_RX_ONLY) then {
                [localize LSTRING(noTransmitIntercom), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
                _canTransmit = false;
            };
        };
    };
};

if (_canTransmit && {_radioId in ACRE_EXTERNALLY_USED_PERSONAL_RADIOS}) then {
    _canTransmit = false;
    [localize LSTRING(noTransmitExternal), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};

if (_canTransmit && {(toLower _radioId) in ACRE_BLOCKED_TRANSMITTING_RADIOS}) then {
    _canTransmit = false;
    [localize LSTRING(alreadyTransmitting), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};

_canTransmit
