#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Handles the key down event for the spectator display.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Key Code <NUMBER>
 * 2: Shift <BOOL>
 * 3: Control <BOOL>
 * 4: Alt <BOOL>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [DISPLAY, 0, false, false, false] call acre_sys_spectator_fnc_handleKeyDown
 *
 * Public: No
 */

params ["_display", "_keyCode", "_shift", "_ctrl", "_alt"];

private _keybinds = ["ACRE2", QGVAR(clearRadios)] call CBA_fnc_getKeybind select 8;

if ([_keyCode, [_shift, _ctrl, _alt]] in _keybinds) exitWith {
    // Clear spectator radios list
    ACRE_SPECTATOR_RADIOS = [];

    // Set list entries to unchecked
    private _ctrlList = _display displayCtrl IDC_RADIOS_LIST;

    for "_index" from 0 to (lbSize _ctrlList - 1) do {
        _ctrlList lbSetPicture [_index, ICON_UNCHECKED];
    };

    // Remove all current speakers and refresh speaking list
    _display setVariable [QGVAR(speakers), [] call CBA_fnc_hashCreate];
    _display call FUNC(refreshSpeakingList);

    // Play sound to alert user
    playSound "3DEN_notificationWarning";

    true // handled
};

false
