#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the ACRE notification system.
 *
 * Arguments:
 * 0: Notification display <DISPLAY>
 * 1: Buffer pointer (defines at which position the notification is shown) <NUMBER>
 * 2: Hint Configuration (see acre_sys_list_fnc_displayHint) <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display, 0, ["Title", "L1", "L2", [1, 1, 1, 1]]] call acre_sys_list_fnc_showHintBox
 *
 * Public: No
 */

params ["_display", "_bufferPointer", "_config"];
_config params ["_title", "_line1", "_line2", "_color"];

// Recreate controls to reset fade and position
ctrlDelete (_display displayCtrl (IDC_FLASH_GROUP + _bufferPointer));
ctrlDelete (_display displayCtrl (IDC_GROUP + _bufferPointer));

private _ctrlFlash = _display ctrlCreate [QGVAR(radioCycleDisplayFlash), IDC_FLASH_GROUP + _bufferPointer];
private _ctrl = _display ctrlCreate [QGVAR(radioCycleDisplay), IDC_GROUP + _bufferPointer];

// Position by buffer pointer
private _position = ctrlPosition _ctrl;
_position set [1, (_position select 1) - _bufferPointer * (_position select 3)];

_ctrl ctrlSetPosition _position;
_ctrl ctrlCommit 0;

// Flash
_color set [3, 1];
(_ctrlFlash controlsGroupCtrl IDC_CONTROLFLASH) ctrlSetBackgroundColor _color;
(_ctrlFlash controlsGroupCtrl IDC_CONTROLFLASH) ctrlSetFade 1;
(_ctrlFlash controlsGroupCtrl IDC_CONTROLFLASH) ctrlCommit 0.15;

// Notification
(_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDBLACK) ctrlSetBackgroundColor GVAR(HintBackgroundColor);
(_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDBLACK) ctrlCommit 0;

_color set [3, 0.2];
(_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDCOLOR) ctrlSetBackgroundColor _color;

(_ctrl controlsGroupCtrl IDC_CONTROLTITLE) ctrlSetText _title;
(_ctrl controlsGroupCtrl IDC_CONTROLLINE1) ctrlSetText _line1;
(_ctrl controlsGroupCtrl IDC_CONTROLLINE2) ctrlSetText _line2;
(_ctrl controlsGroupCtrl IDC_CONTROLTITLE) ctrlSetFont GVAR(HintTextFont);
(_ctrl controlsGroupCtrl IDC_CONTROLLINE1) ctrlSetFont GVAR(HintTextFont);
(_ctrl controlsGroupCtrl IDC_CONTROLLINE2) ctrlSetFont GVAR(HintTextFont);

_color set [3, 0.8];
{
    (_ctrl controlsGroupCtrl _x) ctrlSetTextColor _color;
    (_ctrl controlsGroupCtrl _x) ctrlCommit 0;
} forEach [IDC_CONTROLTITLE, IDC_CONTROLLINE1, IDC_CONTROLLINE2];
