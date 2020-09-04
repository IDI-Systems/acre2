#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the ACRE notification system.
 *
 * Arguments:
 * 0: Display of CutRsc <DISPLAY>
 * 2: Buffer pointer (defines at which position the notification is shown) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_this select 0, acre_sys_list_hintBufferPointer] call acre_sys_list_fnc_showHintBox
 *
 * Public: No
 */

params ["_hintIDD", "_bufferpointer"];

_hintIDD = findDisplay _hintIDD;

private _ctrlFlash = _hintIDD ctrlCreate [QGVAR(radioCycleDisplayFlash), IDC_FLASH_GROUP + _bufferpointer];
private _ctrl = _hintIDD ctrlCreate [QGVAR(radioCycleDisplay), IDC_GROUP + _bufferpointer];


// Flash
private _color = GVAR(hintColor);
_color set [3, 1];
(_ctrlFlash controlsGroupCtrl IDC_CONTROLFLASH) ctrlSetBackgroundColor _color;

private _position = ctrlPosition (_ctrlFlash controlsGroupCtrl IDC_CONTROLFLASH);

_position set [1, (_position select 1) - _bufferpointer * (_position select 3)];
(_ctrlFlash controlsGroupCtrl IDC_CONTROLFLASH) ctrlSetPosition _position;
(_ctrlFlash controlsGroupCtrl IDC_CONTROLFLASH) ctrlCommit 0;

(_ctrlFlash controlsGroupCtrl IDC_CONTROLFLASH) ctrlSetFade 1;
(_ctrlFlash controlsGroupCtrl IDC_CONTROLFLASH) ctrlCommit 0.15;


// Notification
private _translateY = (ctrlPosition (_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDCOLOR)) select 3;

private _position = ctrlPosition (_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDCOLOR);
_position set [1, (_position select 1) - _bufferpointer * _translateY];
(_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDCOLOR) ctrlSetPosition _position;
(_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDCOLOR) ctrlCommit 0;

_position = ctrlPosition (_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDBLACK);
_position set [1, (_position select 1) - _bufferpointer * _translateY];
(_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDBLACK) ctrlSetPosition _position;
(_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDBLACK) ctrlSetBackgroundColor GVAR(HintBackgroundColor);
(_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDBLACK) ctrlCommit 0;


private _color = GVAR(hintColor);
_color set [3, 0.2];
(_ctrl controlsGroupCtrl IDC_CONTROLBACKGROUNDCOLOR) ctrlSetBackgroundColor _color;


(_ctrl controlsGroupCtrl IDC_CONTROLTITLE) ctrlSetText GVAR(hintTitle);
(_ctrl controlsGroupCtrl IDC_CONTROLLINE1) ctrlSetText GVAR(hintLine1);
(_ctrl controlsGroupCtrl IDC_CONTROLLINE2) ctrlSetText GVAR(hintLine2);
(_ctrl controlsGroupCtrl IDC_CONTROLTITLE) ctrlSetFont GVAR(HintTextFont);
(_ctrl controlsGroupCtrl IDC_CONTROLLINE1) ctrlSetFont GVAR(HintTextFont);
(_ctrl controlsGroupCtrl IDC_CONTROLLINE2) ctrlSetFont GVAR(HintTextFont);
{
    _color set [3, 0.8];
    (_ctrl controlsGroupCtrl _x) ctrlSetTextColor _color;

    _position = ctrlPosition (_hintIDD displayCtrl _x);
    _position set [1, (_position select 1) - _bufferpointer * _translateY];

    (_ctrl controlsGroupCtrl _x) ctrlSetPosition _position;
    (_ctrl controlsGroupCtrl _x) ctrlCommit 0;
} forEach [IDC_CONTROLTITLE, IDC_CONTROLLINE1, IDC_CONTROLLINE2];
