#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Displays an ACRE notification in the lower left corner. Capable of holding three lines of text and configurable colors.
 *
 * Arguments:
 * 0: Title String <STRING>
 * 1: Line 1 String <STRING>
 * 2: Line 2 String <STRING>
 * 3: Optional display duration <NUMBER> (default: 1)
 * 4: Optional color in RGBA format <ARRAY> (default: [1, 0.8, 0, 1])
 *
 * Return Value:
 * Name of cutRsc layer <STRING>
 *
 * Example:
 * ["Title Line", "Line 1", "Line 2", 1, [1, 1, 1, 1]] call acre_sys_list_fnc_displayHint
 *
 * Public: No
 */

params [
    "_hintTitle",
    "_hintLine1",
    "_hintLine2",
    ["_hintDuration", -1],
    ["_hintColor", [1, 0.8, 0, 1]]
];

GVAR(hintTitle) = _hintTitle;
GVAR(hintLine1) = _hintLine1;
GVAR(hintLine2) = _hintLine2;
GVAR(hintColor) = _hintColor;

private _hintBufferPointer = (GVAR(hintBuffer) find 0) max 0;
GVAR(hintBuffer) set [_hintBufferPointer, 1];

// DEBUG
private _hintIDD = 312; // Zeus
if (isNull (findDisplay _hintIDD)) then {
    _hintIDD = 46; // Main
    diag_log "no Zeus";
    if (isNull (findDisplay _hintIDD)) then {
        diag_log "no display";
    };
};

[_hintIDD, _hintBufferPointer] call FUNC(showHintBox);

if (_hintDuration > 0) then {
    [FUNC(hideHint), [_hintIDD, _hintBufferPointer], _hintDuration] call CBA_fnc_waitAndExecute;
};

[_hintIDD, _hintBufferPointer]
