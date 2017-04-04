/*
 * Author: ACRE2Team
 * Handles the return of a unique ID for a new rack from the server.
 *
 * Arguments:
 * 0: Vehicle rack is attached to <OBJECT>
 * 1: Unique rack ID <STRING>
 * 2: Unique ID Number <NUMBER>
 * 3: Replacement ID - if the rack is replacing an older rack <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [ARGUMENTS] call acre_sys_rack_fnc_onReturnRackId
 *
 * Public: No
 */
#include "script_component.hpp"

LOG("HIT CALLBACK");

params ["_entity", "_class", "_returnIdNumber", "_replacementId"];

private _dataHash = HASH_CREATE;

// diag_log text format ["acre_sys_data_radioData: %1", acre_sys_data_radioData];

HASH_SET(EGVAR(sys_data,radioData), _class, _dataHash);
_idRelation = [_entity, _entity];
HASH_SET(EGVAR(sys_server,objectIdRelationTable), _class, _idRelation);
if (_replacementId != "") then {
    _radioData = HASH_GET(EGVAR(sys_data,radioData), _replacementId);
    HASH_SET(EGVAR(sys_data,radioData), _class, HASH_COPY(_radioData));
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
