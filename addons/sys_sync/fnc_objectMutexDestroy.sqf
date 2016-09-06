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

private["_object", "_caller", "_mutexName", "_mutex", "_lockStatus", "_remoteCall"];
params["_caller","_object", "_mutexName"];

if( (count _this) > 3) then {
    _remoteCall = true;
} else {
    _remoteCall = false;
};

if( !(local _object) && !_remoteCall) exitWith {
    [ACRE_EVENT(om_d), [_caller, _object, _mutexName] ] call CALLSTACK(LIB_fnc_globalEvent);

    waitUntil { // OK
        _mutex = _object getVariable _mutexName;
        (isNil "_mutex")
    };

    true
};

// object mutex are formated [status, lock_owner, objOwner]
// wait until its unlocked to destroy it
if(isServer) then {
    [GVAR(serverObject), _object, _mutexName] call FUNC(objectMutexLock);
} else {
    [acre_player, _object, _mutexName] call FUNC(objectMutexLock);
};
// this means the object is local to us, we create the mutex

_object setVariable [_mutexName, nil, true];
