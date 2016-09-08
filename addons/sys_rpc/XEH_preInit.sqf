#include "script_component.hpp"

ADDON = false;

PREP(addProcedure);
PREP(callRemoteProcedure);
PREP(handleData);

GVAR(procedures) = HASH_CREATE;

ADDON = true;
