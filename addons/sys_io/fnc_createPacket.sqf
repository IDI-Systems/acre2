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

private["_prefix"];

params["_type",["_message",""],["_id","ccddeeff"]];

_prefix = PACKET_PREFIX;

TRACE_4("Created packet ", _prefix, _type, _id, _message);
format["%1%2%3%4", _prefix, _type, _id, _message]
