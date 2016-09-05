//fnc_acreEvent.sqf
 
#include "script_component.hpp"

TRACE_1("ACRE DATA EVENT",_this);
private _return = nil;

private _systemReturn = _this call FUNC(processSysEvent);
private _radioReturn = _this call FUNC(processRadioEvent);

TRACE_2("ACRE DATA EVENT RETURN",_systemReturn,_radioReturn);
if(isNil "_radioReturn" && !isNil "_systemReturn") then {
	_return = _systemReturn;
} else {
	if(!isNil "_radioReturn") then {
		_return = _radioReturn;
	};
};

if(isNil "_return") exitWith { nil };
_return