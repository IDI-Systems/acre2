/*
 * Author: ACRE2Team
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId", "", "", "", ""];

// Prevent radio from being opened if it is externally used
if (_radioId in ACRE_ACTIVE_EXTERNAL_RADIOS) exitWith {
    [ELSTRING(sys_external,noOpenGUI), ICON_RADIO_CALL] call EFUNC(sys_core,displayNotification);
};

disableSerialization;
GVAR(currentRadioId) = _radioId;
createDialog "PRC148_RadioDialog";
GVAR(PFHId) = ADDPFH(DFUNC(PFH), 0.33, []);
true
