//fnc_setText.sqf
#include "script_component.hpp"

private ["_textArray", "_length", "_i", "_formatArray", "_count", "_valCount", "_formatChar", "_val"];
params["_display", "_row", "_range", "_text", ["_format",""]]; 

if(!IS_STRING(_text)) then {
	_text = str _text;
};
_textArray = toArray _text;

_range params ["_start", "_end"];

_length = ((_end-_start) min ((count _textArray)-1));
if(_format == "") then {
	for "_i" from 0 to _length do {
		(_display displayCtrl (_row+_start+_i)) ctrlSetText (toString [(_textArray select (_i))]);
	};
} else {
	_formatArray = toArray _format;
	_count = (count _formatArray)-1;
	_valCount = (count _textArray)-1;
	while {_count >= 0} do {
		_formatChar = toString [_formatArray select _count];
		_val = "";
		if(_formatChar == "#") then {
			if(_valCount >= 0) then {
				_val = (toString [(_textArray select _valCount)]);
				_valCount = _valCount - 1;
			} else {
				_val = "";
			};
		} else {
			_val = _formatChar;
		};
		(_display displayCtrl (_row+_start+_count)) ctrlSetText _val;
		_count = _count - 1;
	};
};