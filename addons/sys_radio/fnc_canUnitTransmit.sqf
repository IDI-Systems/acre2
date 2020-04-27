#include "script_component.hpp"
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

params ["_radioId"];

private _canTransmit = true;
private _vehicle = vehicle acre_player;

if (acre_player getVariable [QEGVAR(sys_core,isDisabled), false]) exitWith {
    false
};

if (_vehicle != acre_player) then {
    if ((_radioId in ACRE_ACCESSIBLE_RACK_RADIOS || {_radioId in ACRE_HEARABLE_RACK_RADIOS}) && {[_radioId, acre_player] call EFUNC(sys_rack,isRadioHearable)}) then {
        // Check if radio is in intercom.
        if ([_radioId, acre_player, _vehicle] call EFUNC(sys_rack,isRadioHearable)) then {
            private _functionality = [_radioId, _vehicle, acre_player] call EFUNC(sys_intercom,getRackRxTxCapabilities);
            if (_functionality == RACK_NO_MONITOR || _functionality == RACK_RX_ONLY) then {
                [[ICON_RADIO_CALL], [localize LSTRING(noTransmitIntercom)], true] call CBA_fnc_notify;
                _canTransmit = false;
            };
        };
    };
};

if (_canTransmit && {_radioId in ACRE_EXTERNALLY_USED_PERSONAL_RADIOS}) exitWith {
    [[ICON_RADIO_CALL], [localize LSTRING(noTransmitExternal)], true] call CBA_fnc_notify;
    false
};

if (_canTransmit && {_radioId in ACRE_BLOCKED_TRANSMITTING_RADIOS}) exitWith {
    [[ICON_RADIO_CALL], [localize LSTRING(alreadyTransmitting)], true] call CBA_fnc_notify;
    false
};

_canTransmit
