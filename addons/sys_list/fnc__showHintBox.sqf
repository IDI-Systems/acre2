/*
 * Author: ACRE2Team
 * Handles the ACRE notification system
 *
 * Arguments:
 * 0: Display of CutRsc <DISPLAY>
 * 1: Type (either flashing background or actual notification) <NUMBER>
 * 2: Buffer pointer (defines at which position the notification is shown) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [(_this select 0), 0, acre_sys_list_hintBufferPointer] call acre_sys_list_fnc__showHintBox";
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_hintIDD", "_type", "_bufferpointer"];

if (_type == 0) then {
    private _color = GVAR(hintColor);
    _color set [3, 1];
    (_hintIDD displayCtrl 19105) ctrlSetBackgroundColor _color;

    private _position = ctrlPosition (_hintIDD displayCtrl 19105);

    _position set [1, (_position select 1) - _bufferpointer * (_position select 3)];
    (_hintIDD displayCtrl 19105) ctrlSetPosition _position;
    (_hintIDD displayCtrl 19105) ctrlCommit 0;
};

if (_type == 1) then {
    private _translateY = (ctrlPosition (_hintIDD displayCtrl 19105)) select 3; // May be replaced by MACRO

    private _position = ctrlPosition (_hintIDD displayCtrl 19105);
    _position set [1, (_position select 1) - _bufferpointer * _translateY];
    (_hintIDD displayCtrl 19105) ctrlSetPosition _position;
    (_hintIDD displayCtrl 19105) ctrlCommit 0;

    _position = ctrlPosition (_hintIDD displayCtrl 19106);
    _position set [1, (_position select 1) - _bufferpointer * _translateY];
    (_hintIDD displayCtrl 19106) ctrlSetPosition _position;
    (_hintIDD displayCtrl 19106) ctrlCommit 0;

    private _color = GVAR(hintColor);
    _color set [3, 0.2];
    (_hintIDD displayCtrl 19105) ctrlSetBackgroundColor _color;


    (_hintIDD displayCtrl 19100) ctrlSetText GVAR(hintTitle);
    (_hintIDD displayCtrl 19101) ctrlSetText GVAR(hintLine1);
    (_hintIDD displayCtrl 19102) ctrlSetText GVAR(hintLine2);
    {
        //private _color = GVAR(hintColor);
        _color set [3, 0.8];
        (_hintIDD displayCtrl _x) ctrlSetTextColor _color;

        _position = ctrlPosition (_hintIDD displayCtrl _x);
        _position set [1, (_position select 1) - _bufferpointer * _translateY];
        
        (_hintIDD displayCtrl _x) ctrlSetPosition _position;
        (_hintIDD displayCtrl _x) ctrlCommit 0;
    } forEach [19100, 19101, 19102];
};
