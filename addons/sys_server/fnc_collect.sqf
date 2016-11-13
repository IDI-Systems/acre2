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

params ["_radioId"];


private _baseClass = configFile >> "CfgWeapons" >> _radioId;
if (!isClass _baseClass) then { _baseClass = configFile >> "CfgVehicles" >> _radioId; };

private _baseRadio = getText (_baseClass >> "acre_baseClass");
private _idNumber = getNumber(_baseClass >> "acre_uniqueId");
private _keyIndex = (GVAR(radioIdMap) select 0) find (toLower _baseRadio);

if(_keyIndex != -1) then {
    private _newIds = ((GVAR(radioIdMap) select 1) select _keyIndex) - [_idNumber];
    (GVAR(radioIdMap) select 1) set[_keyIndex, _newIds];
    GVAR(masterIdList) = GVAR(masterIdList) - [_radioId];
    GVAR(markedForGC) = GVAR(markedForGC) - [_radioId];
    [QGVAR(clientGCRadio), [_radioId]] call CALLSTACK(CBA_fnc_globalEvent);
    HASH_SET(acre_sys_data_radioData, _radioId, nil);
    HASH_SET(GVAR(markedForGCData), _radioId, nil);
} else {
    WARNING_1("A unique radio of a never initialized base class was attempted to be collected! Possible gear script issue on radio: %1!",_baseRadio);
};
