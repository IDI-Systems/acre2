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
 * [ARGUMENTS] call acre_sys_data_fnc_serverHandleJip
 *
 * Public: No
 */

private _client = _this;
private _radioData = GVAR(radioData) call FUNC(serialize);
private _idTable = EGVAR(sys_server,masterIdTable) call FUNC(serialize);
private _jipData = [_radioData, _idTable];
if (ACRE_DEBUG_DATA_SYNC > 0) then {
    INFO_4("Data Sync for acre_player: %1 [%2,%3] - %4KB",name _client,netId _client,owner _client,(count (toArray (str _jipData)))/1024);
} else {
    INFO_3("Data Sync for acre_player: %1 [%2,%3]",name _client,netId _client,owner _client);
};
ACREjipc = _jipData;

(owner _client) publicVariableClient "ACREjipc";
