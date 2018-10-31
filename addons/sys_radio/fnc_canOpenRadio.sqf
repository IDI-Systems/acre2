#include "script_component.hpp"
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

params ["_radioId"];

private _canOpenRadio = true;
private _vehicle = vehicle acre_player;

if (_vehicle != acre_player) then {
    if (_canOpenRadio && {_radioId in ACRE_ACCESSIBLE_RACK_RADIOS} && {isTurnedOut acre_player}) then {
        _canOpenRadio = false;
        [localize LSTRING(noGuiTurnedOut), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
};

/*
 * Logic: racked radios in intercom or personal radios from another user (handset or headset) cannot be opened.
 */
if (_radioId in ACRE_HEARABLE_RACK_RADIOS || {_radioId in ACRE_ACTIVE_EXTERNAL_RADIOS && !([_radioId] call FUNC(isManpackRadio))}) then {
    _canOpenRadio = false;
    if (_radioId in ACRE_ACTIVE_EXTERNAL_RADIOS) then {
        [localize LSTRING(noGuiExternal), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    } else {
        [localize LSTRING(noGuiSeat), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    };
};

/* Logic:
 * Radios that can be opened simultaneously by different players are accessible rack radios (ACRE_ACCESSIBLE_RACK_RADIOS), externally used manpack radios
 * (ACRE_ACTIVE_EXTERNAL_RADIOS) and owned manpack radios that are being shared (ACRE_EXTERNALLY_USED_MANPACK_RADIOS)
 */
if (_radioId in ACRE_ACCESSIBLE_RACK_RADIOS || {_radioId in ACRE_ACTIVE_EXTERNAL_RADIOS} || {_radioId in ACRE_EXTERNALLY_USED_MANPACK_RADIOS}) then {
    if ([_radioId, "getState", "radioGuiOpened"] call EFUNC(sys_data,dataEvent)) then {
        _canOpenRadio = false;
        [localize LSTRING(alreadyOpenRadio), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
    } else {
        /* Check if in the server, there is a radio registered as opened. This is done in order to prevent race conditions when two players try to
         * simultaneously open a radio. We do not want fights because of ACRE2.
         */
         [QEGVAR(sys_server,openRadioCheck), [_radioId, acre_player]] call CBA_fnc_serverEvent;
    };
};

if (!_canOpenRadio) then {
    GVAR(currentRadioDialog) = "";  // Reset current radio gui that was initialised during the EFUNC(sys_data,interactEvent) call
};

_canOpenRadio
