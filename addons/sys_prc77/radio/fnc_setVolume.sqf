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

params["_radioId", "_event", "_eventData", "_radioData"];

TRACE_1("SETTING CURRENT VOLUME",_this);
HASH_SET(_radioData,"volume",_eventData);
