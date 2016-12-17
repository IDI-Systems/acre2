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

params ["_prepend", "_currentRadioList"];

private _sortList = [];

private _toRemove = [];
private _sortList = _currentRadioList + [];
{
    if (!(_x in _currentRadioList)) then {
        PUSH(_toRemove, _x);
    } else {
        REM(_sortList, _x);
    };
} forEach _prepend;
{ REM(_prepend, _x); } forEach _toRemove;

private _return = _prepend + _sortList;

[_prepend, _return]
