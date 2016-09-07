#include "script_component.hpp"

if(!isServer) exitWith { true };

DFUNC(srv_mutexCreate) = {
    private["_mutexName", "_sender", "_fullName"];
    _mutexName = _this select 0;

    TRACE_1("", _this);

    _fullName = ACRE_SYNC(_mutexName);

    if(isNil _fullName) then {
        // create a publicvariable with our special name
        [_fullName + " = [0, nil];true"] call FUNC(runScript);
        publicVariable _fullName;
    };
    // if the else statement hits, mutex was already created anyways

    true
};

DFUNC(srv_mutexDestroy) = {
    private["_mutexName", "_sender"];
    _mutexName = _this select 0;
    _sender = _this select 1;

    _fullName = ACRE_SYNC(_mutexName);
    if(!(isNil _fullName)) then {
        [_fullName + " = nil;true"] call FUNC(runScript);
        publicVariable _fullName;
    };

    true
};

DFUNC(srv_mutexLock) = {
    private["_mutexName", "_sender", "_mutex", "_owner", "_locked"];
    _mutexName = _this select 0;
    _sender = _this select 1;

    _fullName = ACRE_SYNC(_mutexName);
    _mutex = [_fullName] call FUNC(runScript);

    _locked = _mutex select 0;
    _owner = _mutex select 1;

    TRACE_2("", _owner, _sender);
    if(_locked == 1) then {
        // wait until its not locked by someone other than us
        if(_owner != _sender) then {
            waitUntil { // OK
                _mutex = [_fullName] call FUNC(runScript);
                _locked = _mutex select 0;

                !(_locked == 1)
            };
        };
    };

    // now its freed
    _mutex = [1, _sender];
    TRACE_1("gogogo", _mutex);

    [_fullName + " = _this select 0; true", [_mutex] ] call FUNC(runScript);
    publicVariable _fullName;

    _mutex = [_fullName] call FUNC(runScript);
    TRACE_1("return", _mutex);

    true
};

DFUNC(srv_mutexUnlock) = {
    private["_mutexName", "_sender", "_mutex", "_owner", "_locked"];
    _mutexName = _this select 0;
    _sender = _this select 1;

    _fullName = ACRE_SYNC(_mutexName);
    _mutex = [_fullName] call FUNC(runScript);

    LOG("UNLOCKING");

    _locked = _mutex select 0;
    _owner = _mutex select 1;
    TRACE_2("", _this, _mutex);
    if(_locked == 1) then {
        // wait until its not locked by someone other than us
        if(_owner != _sender) then {
            waitUntil { // OK
                _mutex = [_fullName] call FUNC(runScript);
                _locked = _mutex select 0;

                !(_locked == 1)
            };
        };
    };

    // now its freed
    _mutex = [0, _sender];
    TRACE_1("gogogo", _mutex);

    [_fullName + " = _this select 0; true", [_mutex] ] call FUNC(runScript);
    publicVariable _fullName;

    _mutex = [_fullName] call FUNC(runScript);
    TRACE_1("return", _mutex);


    true
};

// create our server ownership game logic
GVAR(serverOwner_group) = createGroup sideLogic;
"logic" createUnit [[1,1,1], GVAR(serverOwner_group)];
GVAR(serverObject) = (units GVAR(serverOwner_group)) select 0;
GVAR(serverObject) setPosASL [0,0,0];
GVAR(serverObject) setVariable ["created", "created", true];
publicVariable QUOTE(GVAR(serverObject));
