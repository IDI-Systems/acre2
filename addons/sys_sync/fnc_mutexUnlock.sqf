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

private["_mutex", "_lockStatus", "_localLock"];
params["_caller", "_object", "_mutexName"];

if( !(local _object) ) exitWith {
    [ACRE_EVENT(om_d), [] ] call CALLSTACK(LIB_fnc_globalEvent);

    waitUntil { // OK
        _mutex = _object getVariable _mutexName;
        (isNil "_mutex")
    };

    true
};

// object mutex are formated [status, lock_owner, objOwner]
// wait until its unlocked to destroy it
_mutex = _object getVariable _mutexName;
_lockStatus = _mutex select 0;
if( _lockStatus ) then {
    private["_lockOwner"];
    // is it locked by us, or a remote entity?

    _localLock = false;
    _lockOwner = _mutex select 1;
    if(isServer) then {
        if(_lockOwner == GVAR(serverObject)) then {
            _localLock = true;
        };
    } else {
        if(_lockOwner == acre_player) then {
            _localLock = true;
        };
    };

    if(!_localLock) then {
        waitUntil { // OK
            _mutex = _object getVariable _mutexName;
            _lockStatus = _mutex select 0;

            !(_lockStatus)
        };
    };
};

// this means the object is local to us, we create the mutex
if(!isServer) then {
    _mutex = [false, nil, acre_player];
} else {
    _mutex = [false, nil, GVAR(serverObject)];
};

_object setVariable [_mutexName, _mutex, true];

true
