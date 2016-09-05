//fnc_collect.sqf
#include "script_component.hpp"

params["_radioId"];

private _baseRadio = configName (inheritsFrom (configFile >> "CfgWeapons" >> _radioId));
private _idNumber = getNumber(configFile >> "CfgWeapons" >> _radioId >> "acre_uniqueId");
private _keyIndex = (GVAR(radioIdMap) select 0) find _baseRadio;
if(_keyIndex != -1) then {
    private _newIds = ((GVAR(radioIdMap) select 1) select _keyIndex) - [_idNumber];
    (GVAR(radioIdMap) select 1) set[_keyIndex, _newIds];
    GVAR(masterIdList) = GVAR(masterIdList) - [_radioId];
    GVAR(markedForGC) = GVAR(markedForGC) - [_radioId];
    [QGVAR(clientGCRadio), [_radioId]] call CALLSTACK(LIB_fnc_globalEvent);
    HASH_SET(acre_sys_data_radioData, _radioId, nil);
    HASH_SET(GVAR(markedForGCData), _radioId, nil);
} else {
    diag_log text format["%1 ACRE WARNING: A UNIQUE RADIO OF A NEVER INITIALIZED BASE CLASS WAS ATTEMPTED TO BE COLLECTED, POSSIBLE GEAR SCRIPT ISSUE ON RADIO: %2", diag_tickTime, _baseRadio];
};
