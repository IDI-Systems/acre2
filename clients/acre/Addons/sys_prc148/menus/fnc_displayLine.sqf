//fnc_displayLine.sqf
#include "script_component.hpp"

private ["_textArray", "_size", "_offset", "_offsetArray", "_i"];
params["_display", "_row", "_text", ["_align",0]];

_textArray = toArray(toUpper _text);
_size = 18;
if(_row >= SMALL_LINE_1) then {
	_size = 25;
};
switch _align do {
	case 1: {
		_offset = floor((_size-(count _textArray))/2);
		_offsetArray = [];
		for "_i" from 1 to _offset do {
			PUSH(_offsetArray, (toArray " "));
		};
		_textArray = _offsetArray + _textArray;
	};
	case 2: {
		_offset = floor((_size-(count _textArray)));
		_offsetArray = [];
		for "_i" from 1 to _offset do {
			PUSH(_offsetArray, (toArray " "));
		};
		_textArray = _offsetArray + _textArray;
	};
};
for "_i" from 1 to (count _textArray) do {
	(_display displayCtrl (_row+_i)) ctrlSetText (toString [(_textArray select (_i-1))]);
};
