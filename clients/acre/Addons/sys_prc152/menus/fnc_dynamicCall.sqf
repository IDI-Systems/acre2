//#define DEBUG_MODE_FULL
#include "script_component.hpp"
TRACE_1("dynamicCall", _this);
private["_func", "_ret"];
params["_funcName", "_var"];

if(_funcName isEqualType "") then {
	_func = missionNamespace getVariable format["%1_fnc_%2", QUOTE(ADDON), _funcName];
	_ret = _var call CALLSTACK_NAMED(_func, _funcName);
} else {
	if(_funcName isEqualType {}) then {
		// Calling code
		_ret = _var call CALLSTACK(_funcName);
	};
};

if(isNil "_ret") then {
	nil
};

_ret