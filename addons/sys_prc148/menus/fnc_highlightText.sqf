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
 * [ARGUMENTS] call acre_sys_prc148_fnc_highlightText
 *
 * Public: No
 */

params ["_display", "_row", "_range", ["_highlight", true]];


for "_i" from (_range select 0) to (_range select 1) do {
    private _textCtrl = _display displayCtrl (_row+_i);
    if (_highlight) then {
        _textCtrl ctrlSetBackgroundColor [0,0,0,1];
        _textCtrl ctrlSetTextColor [123/255,179/255,118/255,1];
    } else {
        _textCtrl ctrlSetBackgroundColor [0,0,0,0];
        _textCtrl ctrlSetTextColor [0,0,0,1];
    };
    _textCtrl ctrlCommit 0;
};
