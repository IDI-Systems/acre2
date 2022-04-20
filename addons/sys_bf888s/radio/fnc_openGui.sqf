#include "script_component.hpp"
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
 * ["ACRE_BF888S_ID_1", "openGui", [], [], false] call acre_sys_BF888S_fnc_openGui
 *
 * Public: No
 */

TRACE_1("OPENING GUI", _this);
params ["_radioId", "", "", "", ""];

// Prevent radio from being opened if it is externally used or it is not accessible
if (!([_radioId] call EFUNC(sys_radio,canOpenRadio))) exitWith { false };

GVAR(currentRadioId) = _radioId;
TRACE_2("RADIOID",GVAR(currentRadioId),_radioId);
createDialog "BF888S_RadioDialog";


// Support reserved keybinds on dialog (eg. Tab)
MAIN_DISPLAY call (uiNamespace getVariable "CBA_events_fnc_initDisplayCurator");

[_radioId, true] call EFUNC(sys_radio,setRadioOpenState);

true
