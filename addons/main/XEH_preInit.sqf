#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Due to dependency with FAST_HASH_CREATED_HASHES_NEW and FAST_HASH_POOL, moving this function to sys_core
// causes the game to crash during start-up.
EFUNC(sys_core,fastHashCreate) = {
  if (count FAST_HASH_POOL > 0) exitWith {
      private _ret = (FAST_HASH_POOL deleteAt 0);
      FAST_HASH_CREATED_HASHES_NEW pushBack _ret;
      _ret;
  };
  private _ret = createLocation ["AcreHashType", [-10000,-10000,-10000], 0, 0];
  _ret setText "acre_hash";
  FAST_HASH_CREATED_HASHES_NEW pushBack _ret;
  _ret;
};

// Funtions and definitions of *HASH* variables must remain in main due to the dependency within script_debug.hpp
ACRE_STACK_TRACE = [];
ACRE_STACK_DEPTH = 0;
ACRE_CURRENT_FUNCTION = "";

ACRE_DUMPSTACK_FNC = {
    diag_log text format["ACRE CALL STACK DUMP: %1:%2(%3) DEPTH: %4", _this select 0, _this select 1, ACRE_CURRENT_FUNCTION, ACRE_STACK_DEPTH];
    for "_x" from ACRE_STACK_DEPTH-1 to 0 step -1 do {
        _stackEntry = ACRE_STACK_TRACE select _x;
        _stackEntry params ["_callTickTime", "_callFileName", "_callLineNumb", "_callFuncName", "_nextFuncName", "_nextFuncArgs"];

        if (_callFuncName == "") then {
            _callFuncName = "<root>";
        };

        diag_log text format["%8%1:%2 | %3:%4(%5) => %6(%7)",
            _x+1,
            _callTickTime,
            _callFileName,
            _callLineNumb,
            _callFuncName,
            _nextFuncName,
            _nextFuncArgs,
            toString [9]
            ];
    };
};

if (isNil "FAST_HASH_POOL") then {
    FAST_HASH_POOL = [];
    for "_i" from 1 to 50000 do {
        _newHash = createLocation ["AcreHashType", [-10000,-10000,-10000], 0, 0];
        _newHash setText "acre_hash";
        FAST_HASH_POOL pushBack _newHash;
    };
};
FAST_HASH_TO_DELETE = [];

[FUNC(_hashMonitor), 0.33, []] call cba_fnc_addPerFrameHandler;

FAST_HASH_CREATED_HASHES = [];
FAST_HASH_VAR_STATE = (allVariables missionNamespace);
FAST_HASH_VAR_LENGTH = count FAST_HASH_VAR_STATE;
FAST_HASH_GC_INDEX = 0;
FAST_HASH_GC_FOUND_OBJECTS = [];
FAST_HASH_GC_FOUND_ARRAYS = [];
FAST_HASH_GC_CHECK_OBJECTS = [];
FAST_HASH_CREATED_HASHES_NEW = [];
FAST_HASH_GC_IGNORE = ["fast_hash_gc_found_objects","fast_hash_gc_found_arrays","fast_hash_created_hashes","fast_hash_gc_check_objects","fast_hash_created_hashes_new","fast_hash_var_state","fast_hash_pool","fast_hash_to_delete"];
FAST_HASH_GC_ORPHAN_CHECK_INDEX = 0;

[FUNC(_garbageCollector), 0.25, []] call CBA_fnc_addPerFrameHandler;

INFO("Library loaded.");

ADDON = true;
