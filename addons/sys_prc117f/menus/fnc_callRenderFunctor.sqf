//#define DEBUG_MODE_FULL
#include "script_component.hpp"

private["_onRenderFunction", "_events", "_ret"];
params["_menu"];
TRACE_1("enter", _menu);

if(!isNil "_menu") then {
    if((count _menu) > 5) then {
        _events = MENU_ACTION_EVENTS(_menu);
        if(!isNil "_events" && _events isEqualType [] && count _events > 3) then {
            _onRenderFunction = MENU_ACTION_ONRENDER(_menu);
            if(!isNil "_onRenderFunction") then {
                _ret = [_onRenderFunction, _menu] call FUNC(dynamicCall);
            };
        };
    };
};

if(isNil "_ret") then { _ret = false; }; 

_ret