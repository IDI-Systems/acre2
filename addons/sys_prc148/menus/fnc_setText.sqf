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
 * [ARGUMENTS] call acre_sys_prc148_fnc_setText
 *
 * Public: No
 */

params ["_display", "_row", "_range", "_text", ["_format",""]];

if (!IS_STRING(_text)) then {
    _text = str _text;
};
private _textArray = toArray _text;

_range params ["_start", "_end"];

private _length = ((_end-_start) min ((count _textArray)-1));
if (_format == "") then {
    for "_i" from 0 to _length do {
        (_display displayCtrl (_row+_start+_i)) ctrlSetText (toString [(_textArray select (_i))]);
    };
} else {
    private _formatArray = toArray _format;
    private _count = (count _formatArray)-1;
    private _valCount = (count _textArray)-1;
    while {_count >= 0} do {
        private _formatChar = toString [_formatArray select _count];
        private _val = "";
        if (_formatChar == "#") then {
            if (_valCount >= 0) then {
                _val = (toString [(_textArray select _valCount)]);
                _valCount = _valCount - 1;
            } else {
                _val = "";
            };
        } else {
            _val = _formatChar;
        };
        (_display displayCtrl (_row + _start + _count)) ctrlSetText _val;
        _count = _count - 1;
    };
};
