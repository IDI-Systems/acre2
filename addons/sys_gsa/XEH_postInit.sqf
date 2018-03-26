#include "script_component.hpp"
/*
["vhf30108Item", "init", {[true] call FUNC(initGsa)}, nil, nil, true] call CBA_fnc_addClassEventHandler;
["vhf30108spike", "init", {[false] call FUNC(initGsa)}, nil, nil, true] call CBA_fnc_addClassEventHandler;
*/

// Check whether ACRE2 is fully loaded
ADDPFH(DFUNC(initGsa), 0, []);
