/*
 * Author: AUTHOR
 * SHORT DESCRIPTION
 *
 * Arguments:
 * 0: ARGUMENT ONE <TYPE>
 * 1: ARGUMENT TWO <TYPE>
 *
 * Return Value:
 * RETURN VALUE <TYPE>
 *
 * Example:
 * [ARGUMENTS] call acre_COMPONENT_fnc_FUNCTIONNAME
 *
 * Public: No
 */
#include "script_component.hpp"
TRACE_1("", _this);

uiNamespace setVariable[QUOTE(GVAR(inventoryObject)), nil];
uiNamespace setVariable[QUOTE(GVAR(inventoryContainer)), nil];
