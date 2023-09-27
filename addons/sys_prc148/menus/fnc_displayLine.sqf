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
 * [ARGUMENTS] call acre_sys_prc148_fnc_displayLine
 *
 * Public: No
 */

params ["_display", "_row", "_text", ["_align",0]];

private _textArray = toArray (toUpper _text);
private _size = 18;
if (_row >= SMALL_LINE_1) then {
    _size = 25;
};
switch _align do {
    case 1: {
        private _offset = floor ((_size-(count _textArray))/2);
        private _offsetArray = [];
        for "_i" from 1 to _offset do {
            PUSH(_offsetArray, (toArray " "));
        };
        _textArray = _offsetArray + _textArray;
    };
    case 2: {
        private _offset = floor ((_size-(count _textArray)));
        private _offsetArray = [];
        for "_i" from 1 to _offset do {
            PUSH(_offsetArray, (toArray " "));
        };
        _textArray = _offsetArray + _textArray;
    };
};
for "_i" from 1 to (count _textArray) do {
    (_display displayCtrl (_row + _i)) ctrlSetText (toString [_textArray select (_i - 1)]);
};
