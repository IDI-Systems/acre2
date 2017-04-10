/*
 * Author: ACRE2Team
 * Returns whether the radio can be used to transmit or is only used passively (receive only).
 *
 * Arguments:
 * 0: Classname <STRING>
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

if (_radioId in ACRE_PASSIVE_RACK_RADIOS || _radioId in ACRE_PASSIVE_EXTERNAL_RADIOS) then {
    _canTransmit = false;
    if (_radioId in ACRE_PASSIVE_EXTERNAL_RADIOS) then {
        ["Radio used externally. Only external user may transmit.", ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    } else {
        ["Radio rack not accessible for transmitting from this seat.", ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
};

if (_canTransmit && {(toLower _radioId) in ACRE_BLOCKED_TRANSMITTING_RADIOS}) then {
    _canTransmit = false;
    ["Radio already transmitting.", ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};

_canTransmit
