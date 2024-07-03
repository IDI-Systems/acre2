#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Retrieves a list of keys inside an ACRE 2 hash or variable names defined in an object.
 * This function can be accessed through the macro HASH_KEYS.
 *
 * Arguments:
 * 0: ACRE 2 Hash <HASH>/<OBJECT>
 *
 * Return Value:
 * Array of keys inside an ACRE 2 Hash or object <ARRAY>
 *
 * Example:
 * keys = [acreHash] call acre_main_fnc_fastHashKeys
 * keys = [player] call acre_main_fnc_fastHashKeys
 *
 * Public: No
 */

(allVariables _this) select {!(isNil {_this getVariable _x})};
