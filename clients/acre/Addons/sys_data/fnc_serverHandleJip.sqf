//fnc_serverHandleJip.sqf
#include "script_component.hpp"

private _client = _this;
private _radioData = GVAR(radioData) call FUNC(serialize);
private _idTable = acre_sys_server_masterIdTable call FUNC(serialize);
private _jipData = [_radioData, _idTable];
diag_log text format["%1 ACRE Data Sync for acre_player: %2 [%3,%4] - %5KB", diag_tickTime, (name _client), (netId _client), (owner _client), (count (toArray (str _jipData)))/1024];
ACREjipc = _jipData;

(owner _client) publicVariableClient "ACREjipc";
