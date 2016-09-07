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

private ["_startCtrl", "_endCtrl", "_startPos", "_endPos", "_cursorCtrl"];
params ["_display", "_row", "_range"];

[_display, 99212, true] call FUNC(showIcon); // cursor!
_range params ["_start", "_end"];

_startCtrl = _display displayCtrl (_row+_start);
_endCtrl = _display displayCtrl (_row+_end);

_startPos = ctrlPosition _startCtrl;
_endPos = ctrlPosition _endCtrl;

_cursorCtrl = (_display displayCtrl 99212);

_cursorCtrl ctrlSetPosition [
            (_startPos select 0)-((_endPos select 2)*0.25),
            (_startPos select 1)-((_endPos select 3)*0.125),
            ((_endPos select 0)+((_endPos select 2)+((_endPos select 2)*0.5)))-(_startPos select 0),
            ((_endPos select 1)+((_endPos select 3)+((_endPos select 3)*0.25)))-(_startPos select 1)
        ];

_cursorCtrl ctrlCommit 0;
