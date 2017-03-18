/*
 * Author: ACRE2Team
 * Creates an ACRE2 hash namespace. This function can also be accessed through the macro HASH_CREATE_NAMESPACE.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * ACRE2 Hash Namespace <LOCATION>
 *
 * Example:
 * [] call acre_sys_core_fnc_fastHashCreateNamespace
 *
 * Public: No
 */
#include "script_component.hpp"

createLocation ["ACRE_FastHashNamespaceDummy", [-10000, -10000, -10000], 0, 0]
