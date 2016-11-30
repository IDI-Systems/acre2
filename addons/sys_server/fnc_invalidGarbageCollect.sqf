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

params ["_player", "_radioId", "_radioData"];

WARNING_2("Invalid garbage collection done on radio %1 for player %2! Restoring all data!",_radioId,name _player);

private _baseRadio = configName(inheritsFrom (configFile >> "CfgWeapons" >> _radioId));
private _idNumber = getNumber(configFile >> "CfgWeapons" >> _radioId >> "acre_uniqueId");

private _key = (GVAR(radioIdMap) select 0) find _baseRadio;
if (_key != -1) then {
    private _idArray = ((GVAR(radioIdMap) select 1) select _key);


    PUSH(_idArray, _idNumber);
    PUSH(GVAR(masterIdList), tolower(_radioId));
    HASH_SET(acre_sys_data_radioData, tolower(_radioId), _radioData);

    [QGVAR(restoreInvalidGCData), [_this select 1, _this select 2]] call CALLSTACK(CBA_fnc_globalEvent);
} else {
    WARNING_1("Looking to restore type %1. Could not find!",_radioId);
};
