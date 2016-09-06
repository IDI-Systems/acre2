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

private["_baseClass", "_typeName"];
params["_radioId"];

_baseClass = BASECLASS(_radioId);
_typeName = getText (configFile >> "CfgAcreComponents" >> _baseClass >> "name");

_typeName
