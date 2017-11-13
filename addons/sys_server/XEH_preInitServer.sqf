#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREPServer.hpp"
PREP_RECOMPILE_END;

GVAR(radioIdMap) = [[],[]];
GVAR(masterIdList) = [];

GVAR(markedForGC) = HASH_CREATE; //Entry format key: radioId value: [time_last_recieved,time_last_gc_find,object]

DVAR(ACRE_SPECTATORS_LIST) = []; // TeamSpeak 3 IDs of players spectating
DVAR(ACRE_SPECTATORS_A3_CLIENT_ID_LIST) = []; // clientOwner IDs of players spectating

GVAR(masterIdTable) = HASH_CREATE;
GVAR(doFullSearch) = false;
GVAR(waitingForIdAck) = false;
GVAR(nextSearchTime) = diag_tickTime + 5;

GVAR(unacknowledgedIds) = [];
GVAR(unacknowledgedTable) = HASH_CREATE;

GVAR(radioOpenedBy) = HASH_CREATE;

ADDON = true;

