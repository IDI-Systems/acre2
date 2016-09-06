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

private["_mutex", "_remoteCall"];
params["_object", "_mutexName"];

if( (count _this) > 2) then {
    _remoteCall = true;
} else {
    _remoteCall = false;
};

if( !(local _object) && !_remoteCall) exitWith {
    [ACRE_EVENT(om_c), [_object, _mutexName, true] ] call CALLSTACK(LIB_fnc_globalEvent);
    LOG("Sending remote event");
    waitUntil { // OK
        _mutex = _object getVariable _mutexName;
        !(isNil "_mutex")
    };

    true
};

// object mutex are formated [status, lock_owner, objOwner]
LOG("local object, creating mutex");

// this means the object is local to us, we create the mutex
if(!isServer) then {
    _mutex = [false, nil, acre_player];
} else {
    _mutex = [false, nil, GVAR(serverObject)];
};

_object setVariable [_mutexName, _mutex, true];

true
