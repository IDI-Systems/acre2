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
/*
private["_object", "_caller", "_mutexName", "_mutex", "_lockStatus", "_remoteCall"];
_caller     = _this select 0;
_object     = _this select 1;
_mutexName     = _this select 2;
if( (count _this) > 3) then {
    _remoteCall = true;
} else {
    _remoteCall = false;
};

if( !(local _object) && !_remoteCall) exitWith {
    [ACRE_EVENT(om_d), [_caller, _object, _mutexName, true] ] call CALLSTACK(LIB_fnc_globalEvent);
    LOG("Sending remote event");

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

    _lockOwner = _mutex select 1;
    if(isServer) then {
        if(_lockOwner == GVAR(serverObject)) then {
            _lockStatus = false;
        };
    } else {
        if(_lockOwner == acre_player) then {
            _lockStatus = false;
        };
    };
};

_lockStatus
*/
true
