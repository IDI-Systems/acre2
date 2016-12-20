/*
 * Author: ACRE2Team
 * Retrieves a list of keys inside an ACRE 2 hash or variable names defined in an object.
 * This function can be accessed through the macro HASH_KEYS
 *
 * Arguments:
 * 0: ACRE 2 hash <HASH> or object <OBJECT>
 *
 * Return Value:
 * Array of keys inside an ACRE 2 Hash or object <ARRAY>
 *
 * Example:
 * keys = [acreHash] call acre_sys_core_fnc_fastHashKeys
 * keys = [player] call acre_sys_core_fnc_fastHashKeys
 *
 * Public: No
 */
#include "script_component.hpp"

private _keys = [];
{
    if (!(isNil {_this getVariable _x})) then {
        _keys pushBack _x;
    };
} forEach (allVariables _this);
_keys;
