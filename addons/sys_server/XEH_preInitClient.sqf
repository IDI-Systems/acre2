#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREPClient.hpp"
PREP_RECOMPILE_END;

GVAR(objectIdRelationTable) = HASH_CREATE;
GVAR(pendingIdRelationUpdates) = [];

GVAR(clientGCPFHID) = -1;
GVAR(radioGCWatchList) = [];

ADDON = true;
