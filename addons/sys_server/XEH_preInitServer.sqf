#include "script_component.hpp"

NO_CLIENT;

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREPServer.hpp"
PREP_RECOMPILE_END;

DGVAR(radioIdMap) = [[],[]];

DGVAR(collectionMap) = [];
DGVAR(repopulateGCMap) = true;
DGVAR(colletionMapIndexes) = [0,0];
DGVAR(markedForGC) = [];
DGVAR(markedForGCData) = HASH_CREATE;

DGVAR(collectionTime) = DEFAULT_COLLECTION_TIME;

DGVAR(masterIdList) = [];

DVAR(ACRE_SPECTATORS_LIST) = [];

GVAR(masterIdTable) = HASH_CREATE;
GVAR(unacknowledgedIds) = [];
GVAR(doFullSearch) = false;
GVAR(waitingForIdAck) = false;
GVAR(nextSearchTime) = diag_tickTime + 5;

ADDON = true;
