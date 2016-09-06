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
private["_fullName", "_mutex", "_fail"];

TRACE_1("enter", _this);
waitUntil {!(isNil QUOTE(GVAR(serverObject))) }; // OK

params["_mutexName"];

_fullName = ACRE_SYNC(_mutexName);

if(!isServer) then {
    [ACRE_EVENT(m_l), [_mutexName, acre_player] ] call CALLSTACK(LIB_fnc_globalEvent);
} else {
    [ACRE_EVENT(m_l), [_mutexName, GVAR(serverObject)] ] call CALLSTACK(LIB_fnc_localEvent);
};
LOG("STEP");

waitUntil { // OK
    _fail = false;
    // get the mutex, or fail if its not a valid mutex
    _mutex = [_fullName] call FUNC(runScript);
    if(isNil "_mutex") then {
        _fail = true;
    };
    // check if the locker is us
    TRACE_1("mutex", _mutex);
    _mutex params ["_locker", "_locked"];

    if(_locked == 1) then {
        if(isServer) then {
            if(_locker == GVAR(serverObject)) then {
                _fail = true;
            } else {
                _fail = false;
            };
        } else {
            if(_locker == acre_player) then {
                _fail = true;
            } else {
                _fail = false;
            };
        };
    };
    TRACE_1("", _fail);
    _fail
 };

 TRACE_1("end", nil);

 // double check that our fail exit condition wasnt a bad mutex
 if(isNil "_mutex") then {
    // if it was, than we fail with "false", cause we should always just lock and block until true otherwise
    _fail = false;
 };

 _fail
