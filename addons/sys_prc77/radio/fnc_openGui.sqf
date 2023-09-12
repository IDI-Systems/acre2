#include "..\script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_prc77_fnc_openGui
 *
 * Public: No
 */

TRACE_1("OPENING GUI", _this);
params ["_radioId", "", "", "", ""];

// Prevent radio from being opened if it is externally used or it is not accessible
if !([_radioId] call EFUNC(sys_radio,canOpenRadio)) exitWith { false };

GVAR(currentRadioId) = _radioId;
createDialog "PRC77_RadioDialog";

// Support reserved keybinds on dialog (eg. Tab)
MAIN_DISPLAY call (uiNamespace getVariable "CBA_events_fnc_initDisplayCurator");

[_radioId, true] call EFUNC(sys_radio,setRadioOpenState);

true
