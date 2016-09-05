#include "script_component.hpp"

if(isNil QGVAR(monitorAIHandle)) exitWith { false };

if(GVAR(monitorAIHandle) > -1) then {
    [GVAR(monitorAIHandle)] call EFUNC(sys_sync,perFrame_remove);
};

true