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

private["_fullName"];
params["_mutexName"];

waitUntil {!(isNil QUOTE(GVAR(serverObject))) }; // OK

_fullName = ACRE_SYNC(_mutexName);

if(!isServer) then {
    [ACRE_EVENT(m_d), [_mutexName, acre_player] ] call CALLSTACK(LIB_fnc_globalEvent);
} else {
    [ACRE_EVENT(m_d), [_mutexName, GVAR(serverObject)] ] call CALLSTACK(LIB_fnc_localEvent);
};

waitUntil { (isNil _fullName) }; // OK
