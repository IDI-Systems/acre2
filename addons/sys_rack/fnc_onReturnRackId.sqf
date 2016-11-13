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

LOG("HIT CALLBACK");

params["_entity", "_class", "_returnIdNumber", "_replacementId"];

private _dataHash = HASH_CREATE;

// diag_log text format["acre_sys_data_radioData: %1", acre_sys_data_radioData];

HASH_SET(acre_sys_data_radioData,_class,_dataHash);
_idRelation = [_entity, _entity];
HASH_SET(acre_sys_server_objectIdRelationTable, _class, _idRelation);
if(_replacementId != "") then {
    _radioData = HASH_GET(acre_sys_data_radioData, _replacementId);
    HASH_SET(acre_sys_data_radioData, _class, HASH_COPY(_radioData));
};

 //TODO: test this works.
private _crewPlayers = (crew _entity) select {isPlayer _x};
private _condition = false;
if ((count _crewPlayers > 0)) then {
    if (local (_crewPlayers select 0)) then {
        _condition = true;
    };
} else {
    // FallBack to server.
    if (isServer) then {
        _condition = true;
    };
};


if (_condition) then {
    //Add to vehicle
    [_entity, _class] call FUNC(addRackOnReturn);
    
    ["acre_acknowledgeId", [_class, acre_player]] call CALLSTACK(CBA_fnc_globalEvent);
};
