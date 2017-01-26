/*
 * Author: ACRE2Team
 * Garbage collects a radio locally. This will delete its data.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["acre_prc343_id_1"] call acre_sys_server_fnc_clientGCRadio
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_radioId"];

private _radioList = ([] call EFUNC(sys_data,getPlayerRadioList)) apply {toLower _x};

if ((toLower _radioId) in _radioList) then {
    private _message = format ["ACRE - Your radio '%1' is being garbage collected. The server believes you do not have this radio. You are probably desynced. Please contact the server administrator.",_radioId];
    ERROR(_message);
    _message = format ["ACRE2 - Error - Radio '%1' is being garbage collected but player '%2' still has it locally.",_radioId,profileName];
    _message remoteExec ["diag_log",2]; // Send message to server
};

HASH_SET(acre_sys_data_radioData, _radioId, nil);
if (HASH_HASKEY(acre_sys_data_radioScratchData, _radioId)) then {
    HASH_REM(acre_sys_data_radioScratchData, _radioId);
};
HASH_REM(GVAR(objectIdRelationTable), _radioId);
