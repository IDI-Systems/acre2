#include "script_component.hpp"

[QGVAR(infPhoneEventCalling), {[FUNC(infantryPhoneRingingPFH), 1, _this] call CBA_fnc_addPerFrameHandler}] call CBA_fnc_addEventHandler;

["Tank", "init", FUNC(intercomConfig), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Car_F", "init", FUNC(intercomConfig), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Air", "init", FUNC(intercomConfig), nil, nil, true] call CBA_fnc_addClassEventHandler;
["Boat_F", "init", FUNC(intercomConfig), nil, nil, true] call CBA_fnc_addClassEventHandler;
