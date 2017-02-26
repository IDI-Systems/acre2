/*
 * Author: ACRE2Team
 * Opens the GUI of the radio. This is trigered by either double-click in the inventory,
 * through the ACE interact menu (if available) or through the keybinding "open radio".
 *
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "openGui" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * True <BOOL>
 *
 * Example:
 * [ARGUMENTS] call acre_sys_prc343_fnc_openGui
 *
 * Public: No
 */
#include "script_component.hpp"

TRACE_1("OPENING GUI", _this);
params ["_radioId", "", "", "", ""];

disableSerialization;
GVAR(currentRadioId) = _radioId;
createDialog "PRC343_RadioDialog";


true
