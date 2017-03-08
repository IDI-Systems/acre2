/*
 * Author: ACRE2Team
 * Handles deletion and creation of ACRE2 hashes.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call acre_main_fnc__hashMonitor
 *
 * Public: No
 */
#include "script_component.hpp"

if ((count FAST_HASH_TO_DELETE) > 0) then {
    _init_time = diag_tickTime;
    while {((diag_tickTime - _init_time)*1000) < 2.0 && count FAST_HASH_TO_DELETE > 0} do {
        _hash = FAST_HASH_TO_DELETE deleteAt 0;
        deleteLocation _hash;
        private _newHash = call CBA_fnc_createNamespace;
        _newHash setText "acre_hash";
        FAST_HASH_POOL pushBack _newHash;
    };
};
if ((count FAST_HASH_POOL) <= ((count FAST_HASH_CREATED_HASHES)*0.1)) then {
    for "_i" from 1 to 10 do {
        private _newHash = call CBA_fnc_createNamespace;
        _newHash setText "acre_hash";
        FAST_HASH_POOL pushBack _newHash;
    };
};
