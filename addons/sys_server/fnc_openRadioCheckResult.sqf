/*
 * Author: ACRE2Team
 * Handles the result of checking if a radio is opened.
 *
 * Arguments:
 * 0: radio to check <STRING>
 * 1: client Id with opened radio <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc152_id_1", 2] call acre_sys_server_fnc_openRadioCheckResult
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "_radioOpenedBy"];

if (_radioOpenedBy != owner acre_player) then {
    [_radioId, "closeGui"] call EFUNC(sys_data,interactEvent);
    [localize ELSTRING(sys_radio,radioJustOpened), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};
