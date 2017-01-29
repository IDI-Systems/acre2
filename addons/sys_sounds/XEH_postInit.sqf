#include "script_component.hpp"

if (hasInterface) then {
    ["handleLoadedSound", FUNC(handleLoadedSound)] call EFUNC(sys_rpc,addProcedure);
};
