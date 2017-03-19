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
 * ["globalVolume", "1.5"] call acre_sys_core_fnc_garbageCollector
 *
 * Public: No
 */
#include "script_component.hpp"

if (count FAST_HASH_CREATED_HASHES_NEW < ((count FAST_HASH_CREATED_HASHES)*0.1)/2) exitWith {};
// diag_log text format["---------------------------------------------------"];
private _init_time = diag_tickTime;
while {diag_tickTime - _init_time < 0.001 && {FAST_HASH_GC_INDEX < FAST_HASH_VAR_LENGTH}} do {
    private _var_name = FAST_HASH_VAR_STATE select FAST_HASH_GC_INDEX;
    private _x = missionNamespace getVariable [_var_name, nil];

    ACRE_FAST_HASH_GC_INDEX = FAST_HASH_GC_INDEX + 1;
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
            ACRE_FAST_HASH_GC_ORPHAN_CHECK_INDEX = FAST_HASH_GC_ORPHAN_CHECK_INDEX + 1;
            if (!(_check in FAST_HASH_GC_CHECK_OBJECTS)) then {
                FAST_HASH_TO_DELETE pushBack _check;
            };
        };
    } else {
        ACRE_FAST_HASH_VAR_STATE = (allVariables missionNamespace);
        ACRE_FAST_HASH_CREATED_HASHES = FAST_HASH_GC_CHECK_OBJECTS;
        ACRE_FAST_HASH_GC_CHECK_OBJECTS = [];
        ACRE_FAST_HASH_GC_FOUND_ARRAYS = [];
        ACRE_FAST_HASH_VAR_LENGTH = count FAST_HASH_VAR_STATE;
        ACRE_FAST_HASH_GC_INDEX = 0;
        FAST_HASH_CREATED_HASHES append FAST_HASH_CREATED_HASHES_NEW;
        ACRE_FAST_HASH_CREATED_HASHES_NEW = [];
        ACRE_FAST_HASH_GC_FOUND_OBJECTS = [];
        ACRE_FAST_HASH_GC_ORPHAN_CHECK_INDEX = 0;
    };
};
