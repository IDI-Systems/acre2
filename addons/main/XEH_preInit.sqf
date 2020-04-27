#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Funtions and definitions of stack variables must remain in main due to the dependency within script_debug.hpp
ACRE_STACK_TRACE = [];
ACRE_STACK_DEPTH = 0;
ACRE_CURRENT_FUNCTION = "";

// Fast Hashes
// All hash stuff must be in main to guarantee it is compiled and executed first for proper data handling.
if (isNil "ACRE_FAST_HASH_POOL") then {
    ACRE_FAST_HASH_POOL = [];
    for "_i" from 1 to 50000 do {
        ACRE_FAST_HASH_POOL pushBack HASH_CREATE_NAMESPACE;
    };
};
ACRE_FAST_HASH_TO_DELETE = [];

[FUNC(hashMonitor), 0.33, []] call CBA_fnc_addPerFrameHandler;

ACRE_FAST_HASH_CREATED_HASHES = [];
ACRE_FAST_HASH_VAR_STATE = (allVariables missionNamespace);
ACRE_FAST_HASH_VAR_LENGTH = count ACRE_FAST_HASH_VAR_STATE;
ACRE_FAST_HASH_GC_INDEX = 0;
ACRE_FAST_HASH_GC_FOUND_OBJECTS = [];
ACRE_FAST_HASH_GC_FOUND_ARRAYS = [];
ACRE_FAST_HASH_GC_CHECK_OBJECTS = [];
ACRE_FAST_HASH_CREATED_HASHES_NEW = [];
ACRE_FAST_HASH_GC_IGNORE = ["acre_fast_hash_gc_found_objects","acre_fast_hash_gc_found_arrays","acre_fast_hash_created_hashes","acre_fast_hash_gc_check_objects","acre_fast_hash_created_hashes_new","acre_fast_hash_var_state","acre_fast_hash_pool","acre_fast_hash_to_delete"];
ACRE_FAST_HASH_GC_ORPHAN_CHECK_INDEX = 0;

[FUNC(garbageCollector), 0.25, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;
