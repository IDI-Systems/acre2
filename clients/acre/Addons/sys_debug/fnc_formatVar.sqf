//fnc_formatVar.sqf
#include "script_component.hpp"

private ["_var", "_ret", "_array", "_string"];

_var = _this select 0;
_ret = "";
if(!IS_CODE(_var)) then {
	if(IS_STRING(_var)) then {
		_ret = format["%1: ""%2"",", typeName _var, _var];
	} else {
		_ret = format["%1: %2,", typeName _var, _var];
	};
} else {
	_array = toArray (str _var);
	_array resize 100;
	_array = _array - [10,9];
	_string = toString _array;
	_ret = format["%1: %2,", typeName _var, _string];
};
_ret
