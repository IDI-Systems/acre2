//#define DEBUG_MODE_FULL
#include "script_component.hpp"
private["_onEntryFunction", "_events", "_ret"];
params["_menu"];

TRACE_1("enter", _menu);

if(!isNil "_menu") then {
	if((count _menu) > 5) then {
		_events = MENU_ACTION_EVENTS(_menu);
		if(!isNil "_events") then {
			if(_events isEqualType []) then {
				if(count _events > 0) then {
					_onEntryFunction = MENU_ACTION_ONENTRY(_menu);
					if(!isNil "_onEntryFunction") then {
						_ret = [_onEntryFunction, _menu] call FUNC(dynamicCall);
					};
				};
			};
		};
	};
};
if(isNil "_ret") then { _ret = false; }; 
_ret