#include "script_component.hpp"

if (!hasInterface) exitWith {};

["handleLoadedSound", FUNC(handleLoadedSound)] call EFUNC(sys_rpc,addProcedure);
