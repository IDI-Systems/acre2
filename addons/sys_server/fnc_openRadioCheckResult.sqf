#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the result of checking if a radio is opened.
 *
 * Arguments:
 * 0: Radio to check <STRING>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc152_id_1", acre_player] call acre_sys_server_fnc_openRadioCheckResult
 *
 * Public: No
 */

params ["_radioId", "_radioOpenedBy"];

if (_radioOpenedBy != acre_player) then {
    [_radioId, "closeGui"] call EFUNC(sys_data,interactEvent);
    [localize ELSTRING(sys_radio,alreadyOpenRadio), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};
