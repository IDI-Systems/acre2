#include "script_component.hpp"
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
 * [ARGUMENTS] call acre_sys_data_fnc_processSysEvent
 *
 * Public: No
 */

#define DEBUG_MODE_REBUILD

TRACE_1("SYSTEM EVENT ENTER",_this);

params ["_eventKind", "_radioId", "_event", ["_data", []], ["_remote", false]];
private _return = nil;

if (!HASH_HASKEY(GVAR(radioData),_radioId)) exitWith {
    WARNING_2("Non-existent radio '%1' called %2 system event!",_radioId,_event);
    nil
};

private _radioData = HASH_GET(GVAR(radioData),_radioId);

private _cachekey = format ["%1:%2:%3", _eventKind, _radioId, _event];
private _handlerFunction = HASH_GET(GVAR(sysEventCache),_cacheKey);
if (isNil "_handlerFunction") then {
    private _radioBaseClass = BASE_CLASS_CONFIG(_radioId);

    private _interfaceClass = getText (configFile >> "CfgAcreComponents" >> _radioBaseClass >> "InterfaceClasses" >> _eventKind);
    if (_interfaceClass == "") then {
        _interfaceClass = "DefaultInterface";
    };
    _handlerFunction = getText (configFile >> _eventKind >> _interfaceClass >> _event >> "handler");
    HASH_SET(GVAR(sysEventCache),_cachekey,_handlerFunction);
};

if (_handlerFunction != "") then {
    _return = [_radioId, _event, _data, _radioData, _eventKind, _remote] call (missionNamespace getVariable [_handlerFunction, FUNC(noApiSystemFunction)]);
};

if (isNil "_return") exitWith { nil };
_return;
