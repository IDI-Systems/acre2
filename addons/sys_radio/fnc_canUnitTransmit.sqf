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
    if (_radioId in ACRE_ACTIVE_RACK_RADIOS || _radioId in ACRE_PASSIVE_RACK_RADIOS) then {
        // Get rackID
        private _rackId = [_radioId] call EFUNC(sys_rack,getRadioFromRack);
        // Check if radio is in intercom.
        if ([_rackId] call EFUNC(sys_rack,isRackHearable)) then {
            private _rackTxRxConfig = _vehicle getVariable [QEGVAR(sys_intercom,rackTxRxConfig), []];
            {
                if (_x select 0 == _radioId) then {
                    private _functionality = [_x select 1, acre_player] call EFUNC(sys_intercom,getRxTxCapabilities);
                    if (_functionality == RACK_NO_MONITORING || _functionality == RACK_RX_ONLY) then {
                        _canTransmit = false;
                    };
                };
            } forEach _rackTxRxConfig;
        };
    };
};

if (_radioId in ACRE_PASSIVE_RACK_RADIOS || _radioId in ACRE_PASSIVE_EXTERNAL_RADIOS) then {
    _canTransmit = false;
    if (_radioId in ACRE_PASSIVE_EXTERNAL_RADIOS) then {
        [localize LSTRING(noTransmitExternal), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    } else {
        [localize LSTRING(noTransmitSeat), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
};

if (_canTransmit && {(toLower _radioId) in ACRE_BLOCKED_TRANSMITTING_RADIOS}) then {
    _canTransmit = false;
    [localize LSTRING(alreadyTransmitting), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};

_canTransmit
