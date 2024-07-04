#include "script_component.hpp"
/*
 * Author: ACRE2Team
 * Client function to update the local copy of objectIdRelationTable.
 *
 * Arguments:
 * 0: Array of updates, format of update [key,value] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [["acre_prc343_id_1",[acre_player,acre_player]]] call acre_sys_server_fnc_updateIdObjects
 *
 * Public: No
 */

private _update = _this;
if (ACRE_DATA_SYNCED) then {
    {
        HASH_SET(GVAR(objectIdRelationTable),_x select 0,_x select 1);
    } forEach _update;
} else {
    GVAR(pendingIdRelationUpdates) pushBack _update;
};
