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

private _client = _this;
private _radioData = GVAR(radioData) call FUNC(serialize);
private _idTable = EGVAR(sys_server,masterIdTable) call FUNC(serialize);
private _jipData = [_radioData, _idTable];
INFO_4("Data Sync for acre_player: %2 [%3,%4] - %5KB",name _client,netId _client,owner _client,(count (toArray (str _jipData)))/1024);
ACREjipc = _jipData;

(owner _client) publicVariableClient "ACREjipc";
