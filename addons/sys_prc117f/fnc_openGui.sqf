#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Opens the GUI of the radio. This is trigered by either double-click in the inventory,
 * through the ACE interact menu (if available) or through the keybinding "open radio".
 *
 * Arguments:
 * 0: Radio ID <STRING>
 * 1: Event: "openGui" <STRING> (Unused)
 * 2: Event data <ARRAY> (Unused)
 * 3: Radio data <HASH> (Unused)
 * 4: Remote <BOOL> (Unused)
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * ["ACRE_PRC117F_ID_1"] call acre_sys_prc117f_fnc_openGui
 *
 * Public: No
 */

TRACE_1("OPENING GUI",_this);
params ["_radioId", "", "", "", ""];

// Prevent radio from being opened if it is externally used or it is not accessible
if (!([_radioId] call EFUNC(sys_radio,canOpenRadio))) exitWith { false };

GVAR(currentRadioId) = _radioId;
createDialog "Prc117f_RadioDialog";
[] call FUNC(clearDisplay);

// Support reserved keybinds on dialog (eg. Tab)
MAIN_DISPLAY call (uiNamespace getVariable "CBA_events_fnc_initDisplayCurator");

[_radioId, true] call EFUNC(sys_radio,setRadioOpenState);

private _onState = [GVAR(currentRadioId), "getOnOffState"] call EFUNC(sys_data,dataEvent);
if (_onState >= 1) then {
    private _currentMenu = GET_STATE_DEF("currentMenu",GVAR(VULOSHOME));
    [_currentMenu] call FUNC(changeMenu);
} else {
    //[GVAR(LOADING)] call FUNC(changeMenu);
    [GVAR(OFF)] call FUNC(changeMenu);
};

//[ICON_LOADING, true] call DFUNC(toggleIcon);
//[ICON_LOGO, true] call DFUNC(toggleIcon);
//[ICON_BATTERY, true] call DFUNC(toggleIcon);
//[ICON_TRANSMIT, true] call DFUNC(toggleIcon);

//[ROW_LARGE_1, "ABCDEFGHIJKLMNOPQRSTUVWXYZ1", ALIGN_LEFT] call FUNC(setRowText);
//[ROW_LARGE_5, "YXWVUTSRQPONMLKJIHGFEDCBA01", ALIGN_LEFT] call FUNC(setRowText);

//[ROW_SMALL_1, "ABCDEFGHIJKLMNOPQRSTUVWXYZ1", ALIGN_LEFT] call FUNC(setRowText);
//[ROW_SMALL_5, "YXWVUTSRQPONMLKJIHGFEDCBA01", ALIGN_LEFT] call FUNC(setRowText);

//[13, "                         ", ALIGN_LEFT] call FUNC(setRowText);
//[14, "ABCDEFGHIJKLMNOPQRSTUVWXY", ALIGN_LEFT] call FUNC(setRowText);
//[15, "1234567890098765432123456", ALIGN_LEFT] call FUNC(setRowText);


//[21, "XXXXXXXXXXXXXXXXXXXXX", ALIGN_LEFT] call FUNC(setRowText);
//[22, "XXXXXXX", ALIGN_CENTER] call FUNC(setRowText);
//[23, "XXXXXXXXXXXXXXXXXXXXX", ALIGN_RIGHT] call FUNC(setRowText);
//[24, "XXXXXXXXXXXXXXXXXXXXX", ALIGN_LEFT] call FUNC(setRowText);

true
