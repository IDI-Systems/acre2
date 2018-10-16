#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * ACRE2 garbage collector. Run as a per frame event handler.
 *
 * Arguments:
 * Mone
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_main_fnc_garbageCollector
 *
 * Public: No
 */

if (count ACRE_FAST_HASH_CREATED_HASHES_NEW < ((count ACRE_FAST_HASH_CREATED_HASHES)*0.1)/2) exitWith {};
// diag_log text format["---------------------------------------------------"];
private _init_time = diag_tickTime;
while {diag_tickTime - _init_time < 0.001 && {ACRE_FAST_HASH_GC_INDEX < ACRE_FAST_HASH_VAR_LENGTH}} do {
    private _var_name = ACRE_FAST_HASH_VAR_STATE select ACRE_FAST_HASH_GC_INDEX;
    private _x = missionNamespace getVariable [_var_name, nil];

    ACRE_FAST_HASH_GC_INDEX = ACRE_FAST_HASH_GC_INDEX + 1;
    if (!(_var_name in ACRE_FAST_HASH_GC_IGNORE)) then {
        if (IS_HASH(_x)) then {

            ACRE_FAST_HASH_GC_FOUND_OBJECTS pushBack _x;
        } else {
            if (IS_ARRAY(_x)) then {
                // diag_log text format["pushBack: %1: %2", _var_name, _x];
                ACRE_FAST_HASH_GC_FOUND_ARRAYS pushBack _x;
            };
        };
    };
};
// diag_log text format["GC Objects Left: %1", ACRE_FAST_HASH_VAR_LENGTH - ACRE_FAST_HASH_GC_INDEX];

_init_time = diag_tickTime;
while {diag_tickTime - _init_time < 0.001 && {(count ACRE_FAST_HASH_GC_FOUND_ARRAYS) > 0}} do {
    private _array = ACRE_FAST_HASH_GC_FOUND_ARRAYS deleteAt 0;
    {
        if (IS_HASH(_x)) then {
            // diag_log text format["pushBack: %1", _name];
            ACRE_FAST_HASH_GC_FOUND_OBJECTS pushBack _x;
         } else {
            if (IS_ARRAY(_x)) then {
                // diag_log text format["pushBack sub-array: %1", _x];
                ACRE_FAST_HASH_GC_FOUND_ARRAYS pushBack _x;
            };
         };
    } forEach _array;
};
// diag_log text format["GC Arrays Left: %1", (count ACRE_FAST_HASH_GC_FOUND_ARRAYS)];

_init_time = diag_tickTime;
while {diag_tickTime - _init_time < 0.001 && {(count ACRE_FAST_HASH_GC_FOUND_OBJECTS) > 0}} do {
    private _hash = ACRE_FAST_HASH_GC_FOUND_OBJECTS deleteAt 0;
    ACRE_FAST_HASH_GC_CHECK_OBJECTS pushBack _hash;
    private _array = allVariables _hash;
    {
        _x = _hash getVariable _x;
        if (IS_HASH(_x)) then {
            ACRE_FAST_HASH_GC_FOUND_OBJECTS pushBack _x;
         } else {
            if (IS_ARRAY(_x)) then {
                // diag_log text format["pushBack hash-array: %1", _x];
                ACRE_FAST_HASH_GC_FOUND_ARRAYS pushBack _x;
            };
         };
    } forEach _array;
};
// diag_log text format["GC Hashes Left: %1", (count ACRE_FAST_HASH_GC_FOUND_OBJECTS)];

if (ACRE_FAST_HASH_GC_INDEX >= ACRE_FAST_HASH_VAR_LENGTH && {(count ACRE_FAST_HASH_GC_FOUND_ARRAYS) <= 0} && {(count ACRE_FAST_HASH_GC_FOUND_OBJECTS) <= 0}) then {
    if (ACRE_FAST_HASH_GC_ORPHAN_CHECK_INDEX < (count ACRE_FAST_HASH_CREATED_HASHES)) then {
        _init_time = diag_tickTime;
        while {diag_tickTime - _init_time < 0.001 && {ACRE_FAST_HASH_GC_ORPHAN_CHECK_INDEX < (count ACRE_FAST_HASH_CREATED_HASHES)}} do {
            private _check = ACRE_FAST_HASH_CREATED_HASHES select ACRE_FAST_HASH_GC_ORPHAN_CHECK_INDEX;
            ACRE_FAST_HASH_GC_ORPHAN_CHECK_INDEX = ACRE_FAST_HASH_GC_ORPHAN_CHECK_INDEX + 1;
            if (!(_check in ACRE_FAST_HASH_GC_CHECK_OBJECTS)) then {
                ACRE_FAST_HASH_TO_DELETE pushBack _check;
            };
        };
    } else {
        ACRE_FAST_HASH_VAR_STATE = (allVariables missionNamespace);
        ACRE_FAST_HASH_CREATED_HASHES = ACRE_FAST_HASH_GC_CHECK_OBJECTS;
        ACRE_FAST_HASH_GC_CHECK_OBJECTS = [];
        ACRE_FAST_HASH_GC_FOUND_ARRAYS = [];
        ACRE_FAST_HASH_VAR_LENGTH = count ACRE_FAST_HASH_VAR_STATE;
        ACRE_FAST_HASH_GC_INDEX = 0;
        ACRE_FAST_HASH_CREATED_HASHES append ACRE_FAST_HASH_CREATED_HASHES_NEW;
        ACRE_FAST_HASH_CREATED_HASHES_NEW = [];
        ACRE_FAST_HASH_GC_FOUND_OBJECTS = [];
        ACRE_FAST_HASH_GC_ORPHAN_CHECK_INDEX = 0;
    };
};
