#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Lib - @todo put into functions in sys_core and rename to component sys_core across the board

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

/*
EFUNC(lib,fastHashSerialize) = {
    params ["_hash"];
    private _array = ["ACRE_FAST_HASH",[],[]];
    _keys = _array select 1;
    _vals = _array select 2;
    _allVars = (allVariables _hash) - FAST_HASH_DEFAULT_KEYS;
    {
        _keys pushBack _x;
        _vals pushBack (_hash getVariable [_x, nil]);
    } forEach _allVars;
    _array;
};

EFUNC(lib,fastHashDeSerialize) = {
    params ["_array"];
    private _hash = HASH_CREATE;
    _keys = _array select 1;
    _vals = _array select 2;
    {
        HASH_SET(_hash, _x, (_vals select _forEachIndex));
    } forEach _keys;
    _hash;
};
*/
if (isNil "FAST_HASH_POOL") then {
    FAST_HASH_POOL = [];
    for "_i" from 1 to 50000 do {
        _newHash = createLocation ["AcreHashType", [-10000,-10000,-10000], 0, 0];
        _newHash setText "acre_hash";
        FAST_HASH_POOL pushBack _newHash;
    };
};
FAST_HASH_TO_DELETE = [];

private _fnc_hashMonitor = {
    if ((count FAST_HASH_TO_DELETE) > 0) then {
        _init_time = diag_tickTime;
        while {((diag_tickTime - _init_time)*1000) < 2.0 && count FAST_HASH_TO_DELETE > 0} do {
            _hash = FAST_HASH_TO_DELETE deleteAt 0;
            deleteLocation _hash;
            _newHash = createLocation ["AcreHashType", [-10000,-10000,-10000], 0, 0];
            _newHash setText "acre_hash";
            FAST_HASH_POOL pushBack _newHash;
        };
    };
    if ((count FAST_HASH_POOL) <= ((count FAST_HASH_CREATED_HASHES)*0.1)) then {
        for "_i" from 1 to 10 do {
            _newHash = createLocation ["AcreHashType", [-10000,-10000,-10000], 0, 0];
            _newHash setText "acre_hash";
            FAST_HASH_POOL pushBack _newHash;
        };
    };
};
[_fnc_hashMonitor, 0.33, []] call cba_fnc_addPerFrameHandler;
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
private _garbageCollector = {

    if (count FAST_HASH_CREATED_HASHES_NEW < ((count FAST_HASH_CREATED_HASHES)*0.1)/2) exitWith {};
    // diag_log text format["---------------------------------------------------"];
    private _init_time = diag_tickTime;
    while {diag_tickTime - _init_time < 0.001 && {FAST_HASH_GC_INDEX < FAST_HASH_VAR_LENGTH}} do {
        private _var_name = FAST_HASH_VAR_STATE select FAST_HASH_GC_INDEX;
        private _x = missionNamespace getVariable [_var_name, nil];

        FAST_HASH_GC_INDEX = FAST_HASH_GC_INDEX + 1;
        if (!(_var_name in FAST_HASH_GC_IGNORE)) then {
            if (IS_HASH(_x)) then {

                FAST_HASH_GC_FOUND_OBJECTS pushBack _x;
            } else {
                if (IS_ARRAY(_x)) then {
                    // diag_log text format["pushBack: %1: %2", _var_name, _x];
                    FAST_HASH_GC_FOUND_ARRAYS pushBack _x;
                };
            };
        };
    };
    // diag_log text format["GC Objects Left: %1", FAST_HASH_VAR_LENGTH - FAST_HASH_GC_INDEX];

    _init_time = diag_tickTime;
    while {diag_tickTime - _init_time < 0.001 && {(count FAST_HASH_GC_FOUND_ARRAYS) > 0}} do {
        private _array = FAST_HASH_GC_FOUND_ARRAYS deleteAt 0;
        {
            if (IS_HASH(_x)) then {
                // diag_log text format["pushBack: %1", _name];
                FAST_HASH_GC_FOUND_OBJECTS pushBack _x;
             } else {
                if (IS_ARRAY(_x)) then {
                    // diag_log text format["pushBack sub-array: %1", _x];
                    FAST_HASH_GC_FOUND_ARRAYS pushBack _x;
                };
             };
        } forEach _array;
    };
    // diag_log text format["GC Arrays Left: %1", (count FAST_HASH_GC_FOUND_ARRAYS)];

    _init_time = diag_tickTime;
    while {diag_tickTime - _init_time < 0.001 && {(count FAST_HASH_GC_FOUND_OBJECTS) > 0}} do {
        _hash = FAST_HASH_GC_FOUND_OBJECTS deleteAt 0;
        FAST_HASH_GC_CHECK_OBJECTS pushBack _hash;
        private _array = allVariables _hash;
        {
            _x = _hash getVariable _x;
            if (IS_HASH(_x)) then {
                FAST_HASH_GC_FOUND_OBJECTS pushBack _x;
             } else {
                if (IS_ARRAY(_x)) then {
                    // diag_log text format["pushBack hash-array: %1", _x];
                    FAST_HASH_GC_FOUND_ARRAYS pushBack _x;
                };
             };
        } forEach _array;
    };
    // diag_log text format["GC Hashes Left: %1", (count FAST_HASH_GC_FOUND_OBJECTS)];

    if (FAST_HASH_GC_INDEX >= FAST_HASH_VAR_LENGTH && {(count FAST_HASH_GC_FOUND_ARRAYS) <= 0} && {(count FAST_HASH_GC_FOUND_OBJECTS) <= 0}) then {
        if (FAST_HASH_GC_ORPHAN_CHECK_INDEX < (count FAST_HASH_CREATED_HASHES)) then {
            _init_time = diag_tickTime;
            while {diag_tickTime - _init_time < 0.001 && {FAST_HASH_GC_ORPHAN_CHECK_INDEX < (count FAST_HASH_CREATED_HASHES)}} do {
                _check = FAST_HASH_CREATED_HASHES select FAST_HASH_GC_ORPHAN_CHECK_INDEX;
                FAST_HASH_GC_ORPHAN_CHECK_INDEX = FAST_HASH_GC_ORPHAN_CHECK_INDEX + 1;
                if (!(_check in FAST_HASH_GC_CHECK_OBJECTS)) then {
                    FAST_HASH_TO_DELETE pushBack _check;
                };
            };
        } else {
            FAST_HASH_VAR_STATE = (allVariables missionNamespace);
            FAST_HASH_CREATED_HASHES = FAST_HASH_GC_CHECK_OBJECTS;
            FAST_HASH_GC_CHECK_OBJECTS = [];
            FAST_HASH_GC_FOUND_ARRAYS = [];
            FAST_HASH_VAR_LENGTH = count FAST_HASH_VAR_STATE;
            FAST_HASH_GC_INDEX = 0;
            FAST_HASH_CREATED_HASHES append FAST_HASH_CREATED_HASHES_NEW;
            FAST_HASH_CREATED_HASHES_NEW = [];
            FAST_HASH_GC_FOUND_OBJECTS = [];
            FAST_HASH_GC_ORPHAN_CHECK_INDEX = 0;
        };
    };

};
[_garbageCollector, 0.25, []] call CBA_fnc_addPerFrameHandler;

INFO("Library loaded.");

ADDON = true;
