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

private["_mutex", "_lockStatus", "_remoteCall", "_locker"];
params["_caller","_object", "_mutexName"];

if( (count _this) > 3) then {
    _remoteCall = true;
} else {
    _remoteCall = false;
};

if( !(local _object) && !_remoteCall) exitWith {
    [ACRE_EVENT(om_l), [_caller, _object, _mutexName, true] ] call CALLSTACK(LIB_fnc_globalEvent);
    LOG("Sending remote event");

    waitUntil { // OK
        private["_checkRet"];
        _mutex = _object getVariable _mutexName;
        _lockStatus = _mutex select 0;
        _locker = _mutex select 1;
        _checkRet = false;
        if(!(isNil "_locker")) then {
            if(_lockStatus && _locker == _caller) then {
                _checkRet = true;
            };
        };
        _checkRet
    };

    true
};

// object mutex are formated [status, lock_owner, objOwner]
// wait until its unlocked to destroy it
_mutex = _object getVariable _mutexName;
_lockStatus = _mutex select 0;
_locker = _mutex select 1;
TRACE_1("checking", _mutex);
if( _lockStatus ) then {
    if(_locker != _caller) then {
        waitUntil { // OK
            _mutex = _object getVariable _mutexName;
            _lockStatus = _mutex select 0;

            !(_lockStatus)
        };
    };
};
LOG("UNLOCKED, LOCAL LOCKING!");

// this means the object is local to us, we create the mutex
if(!isServer) then {
    _mutex = [true, _caller, acre_player];
} else {
    _mutex = [true, _caller, GVAR(serverObject)];
};

_object setVariable [_mutexName, _mutex, true];

TRACE_1("finished", _mutex);

true
