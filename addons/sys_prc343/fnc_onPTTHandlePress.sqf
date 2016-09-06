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
#define IN 0
#define OUT 1

private _currentView = GET_STATE(currentView);
params ["","_key"];

if(_key == 0) then {
// left click
    private _newView = OUT;
    if(_currentView == OUT) then {
    _newView = IN;
    };
    if(_newView != _currentView) then {
    SET_STATE(currentView, _newView);
    [_newView] call CALLSTACK(FUNC(zoomChannelBlockSelector));
    };
};
