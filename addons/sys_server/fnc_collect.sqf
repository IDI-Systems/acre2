#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Garbage collects a radio. Use only on server this will in turn send an event to garbage collect on all clients.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc343_id_1"] call acre_sys_server_fnc_collect
 *
 * Public: No
 */

params ["_radioId"];
_radioId = toLower _radioId;

private _baseClass = configFile >> "CfgWeapons" >> _radioId;
if (!isClass _baseClass) then { _baseClass = configFile >> "CfgVehicles" >> _radioId; };

private _baseRadio = getText (_baseClass >> "acre_baseClass");
private _idNumber = getNumber (_baseClass >> "acre_uniqueId");
private _keyIndex = (GVAR(radioIdMap) select 0) find (toLower _baseRadio);

if (_keyIndex != -1) then {
    private _newIds = (GVAR(radioIdMap) select 1) select _keyIndex;
    _newIds deleteAt (_newIds find _idNumber);

    (GVAR(radioIdMap) select 1) set [_keyIndex, _newIds];
    GVAR(masterIdList) deleteAt (GVAR(masterIdList) find _radioId);
    HASH_REM(GVAR(markedForGC),_radioId);
    [QGVAR(clientGCRadio), [_radioId]] call CALLSTACK(CBA_fnc_globalEvent);
    HASH_SET(EGVAR(sys_data,radioData), _radioId, nil);
} else {
    WARNING_1("A unique radio of a never initialized base class was attempted to be collected! Possible gear script issue on radio: %1!",_baseRadio);
};
