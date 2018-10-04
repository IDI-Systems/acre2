#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Opens a radio.
 *
 * Arguments:
 * 0: Unique Radio ID <STRING>
 *
 * Return Value:
 * Radio opened <BOOL>
 *
 * Example:
 * ["ACRE_PRC343_ID_1"] call acre_sys_radio_fnc_openRadio
 *
 * Public: No
 */

params ["_radioName"];

if (_radioName != "" && {GVAR(currentRadioDialog) == ""}) then {
    [_radioName, "openGui"] call EFUNC(sys_data,interactEvent);
} else {
    closeDialog 0;
};

true
