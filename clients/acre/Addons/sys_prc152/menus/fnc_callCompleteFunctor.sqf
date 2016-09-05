
#include "script_component.hpp"

private["_onCompleteFunction", "_events", "_ret"];
params["_menu"];

if(!isNil "_menu") then {
	if((count _menu) > 5) then {
		_events = MENU_ACTION_EVENTS(_menu);
		if(!isNil "_events" && _events isEqualType [] && count _events > 1) then {
			_onCompleteFunction = MENU_ACTION_ONCOMPLETE(_menu);
			if(!isNil "_onCompleteFunction") then {
				_ret = [_onCompleteFunction, _menu] call FUNC(dynamicCall);
			};
		};
	};
};
if(isNil "_ret") then { _ret = false; }; 
_ret