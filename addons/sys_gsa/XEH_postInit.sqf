#include "script_component.hpp"

["vhf30108Item", "init", FUNC(initGsa), nil, nil, true] call CBA_fnc_addClassEventHandler;
["vhf30108spike", "init", FUNC(initGsa), nil, nil, true] call CBA_fnc_addClassEventHandler;

systemChat format ["test1"];
