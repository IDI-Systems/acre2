/*
 * Author: ACRE2Team
 * Creates an ACRE2 hash. This function can also be accessed through the macro HASH_CREATE.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * ACRE2 Hash <HASH>
 *
 * Example:
 * [] call acre_sys_core_fnc_fastHashCreate
 *
 * Public: No
 */
#include "script_component.hpp"

if (count ACRE_FAST_HASH_POOL > 0) exitWith {
    private _ret = (ACRE_FAST_HASH_POOL deleteAt 0);
    ACRE_FAST_HASH_CREATED_HASHES_NEW pushBack _ret;
    _ret
};

private _ret = HASH_CREATE_NAMESPACE;
ACRE_FAST_HASH_CREATED_HASHES_NEW pushBack _ret;
_ret
