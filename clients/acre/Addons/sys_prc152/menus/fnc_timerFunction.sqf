#include "script_component.hpp"
private ["_fnc"];
params["_radioId","_endFunction", "_step", "_time"];

TRACE_1("Registering a delayed function!", _this);
GVAR(timerFunction_NextStep) = diag_tickTime + _step;

_fnc = {
	params["_args"];
	_args params ["_time", "_radioId", "_function","_step"];
	
	_onState = [_radioId, "getOnOffState"] call EFUNC(sys_data,dataEvent);
	if(_onState < 0.2) then {
		[(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
	};
	if(diag_tickTime > _time) then {
		[(_this select 1)] call EFUNC(sys_sync,perFrame_remove);
	} else {
		if(diag_tickTime > GVAR(timerFunction_NextStep)) then {

			[_radioId, _step] call _function;
			GVAR(timerFunction_NextStep) = diag_tickTime + _step;
		}
	};
};
ADDPFH(_fnc, 0, ARR_4(diag_tickTime+_time, acre_sys_radio_currentRadioDialog, _endFunction, _step));