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

params ["_radioId", "_event", "_data", "_radioData","_eventKind", "_remote"];

acre_sys_core_speaking_cache_valid = false;
//missionNamespace setVariable [_radioId+"dataCache", nil];
if (_remote) exitWith { true };

TRACE_1("SET DATA EVENT ENTER", _this);
private _baseConfig = inheritsFrom (configFile >> "CfgWeapons" >> _radioId);
private _radioBaseClass = configName ( _baseConfig );

private _interfaceClass = getText(configFile >> "CfgAcreComponents" >> _radioBaseClass >> "InterfaceClasses" >> _eventKind);
if (_interfaceClass == "") then {
    _interfaceClass = "DefaultInterface";
};

private _eventClass = configFile >> _eventKind >> _interfaceClass >> _event;

private _priority = 0;
private _timeToSend = diag_tickTime;

/*if (_eventKind == "CfgAcreDataInterface") then {
    missionNamespace setVariable [_radioId+_event+"dataCache", nil];
};*/

if (isClass _eventClass) then {
    _priority = getNumber (_eventClass >> "priority");
    if (_radioId in GVAR(forceHighPriorityIds)) then {
        _priority = ACRE_DATA_NETPRIORITY_HIGH;
    };
    switch (_priority) do {
        case ACRE_DATA_NETPRIORITY_NONE: {
            _timeToSend = -1;
        };
        case ACRE_DATA_NETPRIORITY_HIGH: {
            _timeToSend = 0;
        };
        case ACRE_DATA_NETPRIORITY_MID: {
            _timeToSend = _timeToSend+1;
        };
        case ACRE_DATA_NETPRIORITY_LOW: {
            _timeToSend = _timeToSend+5;
        };
    };
};
TRACE_1("EVENT PRIORITY",_priority);
if (_priority > ACRE_DATA_NETPRIORITY_NONE) then {
    private _hasUniqueDataKey = getNumber (_eventClass >> "uniqueKey");
    private _found = false;
    {
        private _qEvent = _x;
        _found = false;
        if ((_qEvent select 1) == _radioId && (_qEvent select 2) == _event) then {
            _found = true;
        };
        if (_hasUniqueDataKey == 1 && _found) then {
            if (((_qEvent select 3) select 0) == _data select 0) then {
                _found = true;
            } else {
                _found = false;
            };
        };
        if (_found) exitWith {
            GVAR(eventQueue) set [_forEachIndex, [acre_player, _radioId, _event, _data, _timeToSend, _eventKind]];
            _found = true;
        };
    } forEach GVAR(eventQueue);
    if (!_found) then {
        GVAR(eventQueue) pushBack [acre_player, _radioId, _event, _data, _timeToSend, _eventKind];
        nil; // prevents return pushBack returns number index.
    };
};
