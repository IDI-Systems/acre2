//fnc_invalidGarbageCollect.sqf
#include "script_component.hpp"

params["_player", "_radioId", "_radioData"];

diag_log text format["%1 ACRE ERROR: INVALID GARBAGE COLLECTION DONE ON RADIO %2 FOR acre_player %3, RESTORING ALL DATA!", diag_tickTime, _radioId, (name _player)];

private _baseRadio = configName(inheritsFrom (configFile >> "CfgWeapons" >> _radioId));
private _idNumber = getNumber(configFile >> "CfgWeapons" >> _radioId >> "acre_uniqueId");

private _key = (GVAR(radioIdMap) select 0) find _baseRadio;
if(_key != -1) then {
    private _idArray = ((GVAR(radioIdMap) select 1) select _key);


    PUSH(_idArray, _idNumber);
    PUSH(GVAR(masterIdList), tolower(_radioId));
    HASH_SET(acre_sys_data_radioData, tolower(_radioId), _radioData);

    [QGVAR(restoreInvalidGCData), [_this select 1, _this select 2]] call CALLSTACK(LIB_fnc_globalEvent);
} else {
    diag_log text format["%1 ACRE ERROR: LOOKING TO RESTORE TYPE %2, COULD NOT FIND!", diag_tickTime, _radioId];
};


