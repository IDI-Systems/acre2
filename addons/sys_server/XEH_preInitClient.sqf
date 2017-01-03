#include "script_component.hpp"

NO_DEDICATED;

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREPClient.hpp"
PREP_RECOMPILE_END;

DGVAR(objectIdRelationTable) = HASH_CREATE;
DGVAR(pendingIdRelationUpdates) = [];

ADDON = true;
