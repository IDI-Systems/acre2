//fnc_delayFunction.sqf
#include "script_component.hpp"

private ["_fnc"];
params["_radioId", "_endFunction", "_time"];

_fnc = {
	params["_args"];
	_args params ["_time", "_radioId", "_function", "_funcArgs"];

	_onState = [_radioId, "getOnOffState"] call EFUNC(sys_data,dataEvent);
	if(_onState < 0.2) then {
		[(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
	};
	if(diag_tickTime > _time) then {
		[_radioId, _funcArgs] call _function;
		[(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
	};
};
ADDPFH(_fnc, 0, ARR_3(diag_tickTime+_time, acre_sys_radio_currentRadioDialog, _endFunction));
