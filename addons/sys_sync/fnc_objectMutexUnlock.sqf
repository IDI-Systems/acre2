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

private["_mutex", "_lockStatus", "_remoteCall", "_locker", "_ret"];
params["_caller","_object", "_mutexName"];
if( (count _this) > 3) then {
    _remoteCall = true;
} else {
    _remoteCall = false;
};

if( !(local _object) && !_remoteCall) exitWith {
    [ACRE_EVENT(om_u), [_caller, _object, _mutexName, true] ] call CALLSTACK(LIB_fnc_globalEvent);
    LOG("Sending remote event");

    waitUntil { // OK
        _mutex = _object getVariable _mutexName;
        _lockStatus = _mutex select 0;
        _locker = _mutex select 1;
        !(_lockStatus)
    };

    true
};

// object mutex are formated [status, lock_owner, objOwner]
// wait until its unlocked to destroy it
_ret = true;
_mutex = _object getVariable _mutexName;
_lockStatus = _mutex select 0;
_locker = _mutex select 1;
if( _lockStatus ) then {
    if(_locker != _caller) then {
        _ret = false;
    };
};
LOG("LOCAL UNLOCKING!");

if(_ret) then {
    // this means the object is local to us, we create the mutex
    _mutex = [false, nil, GVAR(serverObject)];

    _object setVariable [_mutexName, _mutex, true];
};

TRACE_1("finished", _mutex);

_ret
