#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Displays an ACRE notification in the lower left corner. Capable of holding three lines of text and configurable colors.
 *
 * Arguments:
 * 0: Unique prefixed ID <STRING>
 * 1: Title String <STRING>
 * 2: Line 1 String <STRING>
 * 3: Line 2 String <STRING>
 * 4: Optional display duration <NUMBER> (default: -1)
 * 5: Optional color in RGBA format <ARRAY> (default: [1, 0.8, 0, 1])
 *
 * Return Value:
 * None
 *
 * Example:
 * ["tag_x", "Title Line", "Line 1", "Line 2", 1, [1, 1, 1, 1]] call acre_sys_list_fnc_displayHint
 *
 * Public: No
 */

params [
    "_id",
    "_title",
    "_line1",
    "_line2",
    ["_duration", -1],
    ["_color", [1, 0.8, 0, 1]]
];

private _displayId = call FUNC(getActiveDisplay);

// Find same ID to overwrite
private _bufferPointer = GVAR(hintBuffer) findIf {
    !(_x isEqualTo []) && {_x select 0 == _id}
};
if (_bufferPointer == -1) then {
    // Find first empty otherwise
    _bufferPointer = (GVAR(hintBuffer) findIf {_x isEqualTo []}) max 0;
};

GVAR(hintBuffer) set [_bufferPointer, [_id, _displayID]];
TRACE_2("display buffer",_bufferPointer,GVAR(hintBuffer));

[_displayID, _bufferPointer, [_title, _line1, _line2, _color]] call FUNC(showHintBox);

if (_duration > 0) then {
    [FUNC(hideHint), _id, _duration] call CBA_fnc_waitAndExecute;
};
