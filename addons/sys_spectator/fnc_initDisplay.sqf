#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initializes ACRE spectator radios handling for the given display.
 * Target function must return the currently focused entity.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Target Function <CODE>
 *
 * Return Value:
 * None
 *
 * Example:
 * [DISPLAY, {}] call acre_sys_spectator_fnc_initDisplay
 *
 * Public: No
 */

params ["_display", "_targetFunction"];

// Add EH to clear radios list using the keybind
_display displayAddEventHandler ["KeyDown", {call FUNC(handleKeyDown)}];

// Add EH to add/remove radios by clicking list entries
private _ctrlList = _display displayCtrl IDC_RADIOS_LIST;
_ctrlList ctrlAddEventHandler ["LBSelChanged", {call FUNC(handleListSelect)}];

// Add PFH to update radios list based on the focused target's radios
[LINKFUNC(handleUpdate), 0, [_display, _targetFunction, []]] call CBA_fnc_addPerFrameHandler;
