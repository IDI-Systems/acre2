/*
 * Author: ACRE2Team
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

private["_action"];

_action = _this select 0;

switch (_action) do {
    case "toggledead": {
        GVAR(spect_muteDead) = !GVAR(spect_muteDead);
        TRACE_1("Toggled muteDead", GVAR(spect_muteDead));
    };
    case "togglealive": {
        GVAR(spect_muteAlive) = !GVAR(spect_muteAlive);
        TRACE_1("Toggled muteAlive", GVAR(spect_muteAlive));
    };
};
