#include "..\script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the event of pressing the PTT handle. It triggers an animation and allows changing the actual block.
 *
 * Arguments:
 * 0: Unused <ANY>
 * 1: Left or right click identifier <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["", 1] call acre_sys_prc343_fnc_onPTTHandlePress
 *
 * Public: No
 */

#define IN 0
#define OUT 1

private _currentView = GET_STATE("currentView");
params ["", "_key"];

if (_key == 0) then {
    // left click
    private _newView = OUT;
    if (_currentView == OUT) then {
        _newView = IN;
    };
    if (_newView != _currentView) then {
        SET_STATE("currentView", _newView);
        [_newView] call CALLSTACK(FUNC(zoomChannelBlockSelector));
    };
};
