#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Initializes ACRE spectator radios handling for the given display.
 * Target function must return the currently focused entity.
 * Visible function must return whether the interface is currently visible.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Target Function <CODE>
 * 2: Visible Function <CODE>
 *
 * Return Value:
 * None
 *
 * Example:
 * [DISPLAY, {objNull}, {true}] call acre_sys_spectator_fnc_initDisplay
 *
 * Public: No
 */

params ["_display", "_targetFunction", "_visibleFunction"];

// Add EH to clear radios list using the keybind
_display displayAddEventHandler ["KeyDown", {call FUNC(handleKeyDown)}];

// Add EH to add/remove radios by clicking list entries
private _ctrlList = _display displayCtrl IDC_RADIOS_LIST;
_ctrlList ctrlAddEventHandler ["LBSelChanged", {call FUNC(handleListSelect)}];

// Hash to track currently speaking units and their respective radio IDs
_display setVariable [QGVAR(speakers), [] call CBA_fnc_hashCreate];

// Add EHs to update the speaking list control when someone starts/stops speaking on spectator radios
private _startedSpeakingID = ["acre_remoteStartedSpeaking", LINKFUNC(handleStartedSpeaking), [_display]] call CBA_fnc_addEventHandlerArgs;
private _stoppedSpeakingID = ["acre_remoteStoppedSpeaking", LINKFUNC(handleStoppedSpeaking), [_display]] call CBA_fnc_addEventHandlerArgs;

// Add PFH to update radios list based on the focused target's radios and speaking list visibility
[LINKFUNC(handleUpdate), 0, [_display, _targetFunction, _visibleFunction, _startedSpeakingID, _stoppedSpeakingID]] call CBA_fnc_addPerFrameHandler;
