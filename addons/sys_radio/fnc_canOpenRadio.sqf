/*
 * Author: ACRE2Team
 * Returns whether the radio can be opened.
 *
 * Arguments:
 * 0: Unique radio ID <STRING>
 *
 * Return Value:
 * Can open radio <BOOL>
 *
 * Example:
 * ["acre_prc152_id_1"] call acre_sys_radio_fnc_canOpenRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId"];

private _canOpenRadio = true;

if ((toLower _radioId) in ACRE_ACTIVE_RACK_RADIOS && {isTurnedOut acre_player}) then {
    _canOpenRadio = false;
    [localize LSTRING(noGuiTurnedOut), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};

if (_radioId in ACRE_ACTIVE_EXTERNAL_RADIOS || _radioId in ACRE_PASSIVE_RACK_RADIOS) then {
    _canOpenRadio = false;
    if (_radioId in ACRE_ACTIVE_EXTERNAL_RADIOS) then {
        [localize LSTRING(noGuiExternal), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    } else {
        [localize LSTRING(noGuiSeat), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
};

_canOpenRadio
