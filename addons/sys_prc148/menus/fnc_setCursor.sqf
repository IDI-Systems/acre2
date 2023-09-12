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
 * [ARGUMENTS] call acre_sys_prc148_fnc_setCursor
 *
 * Public: No
 */

params ["_display", "_row", "_range"];

[_display, 99212, true] call FUNC(showIcon); // cursor!
_range params ["_start", "_end"];

private _startCtrl = _display displayCtrl (_row + _start);
private _endCtrl = _display displayCtrl (_row + _end);

private _startPos = ctrlPosition _startCtrl;
private _endPos = ctrlPosition _endCtrl;

private _cursorCtrl = (_display displayCtrl 99212);

_cursorCtrl ctrlSetPosition [
            (_startPos select 0) - ((_endPos select 2)*0.25),
            (_startPos select 1) - ((_endPos select 3)*0.125),
            ((_endPos select 0) + ((_endPos select 2) + ((_endPos select 2)*0.5))) - (_startPos select 0),
            ((_endPos select 1) + ((_endPos select 3) + ((_endPos select 3)*0.25))) - (_startPos select 1)
        ];

_cursorCtrl ctrlCommit 0;
