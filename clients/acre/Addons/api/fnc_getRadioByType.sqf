#include "script_component.hpp"
private ["_array", "_radioId", "_ret"];
params ["_radioType"];

_ret = nil;

if((count _this) > 1) then {
	_array = _this select 1;
	if(IS_OBJECT(_array)) then {
		_array = [_array] call EFUNC(lib,getGear);
	};
} else {
	_array = [] call FUNC(getCurrentRadioList);
};


{
	_radioId = _x;
	if( ([_radioId, _radioType] call FUNC(isKindOf) ) ) exitWith {
		_ret = _radioId;
	};
} forEach _array;

if(isNil "_ret") exitWith { nil };
_ret